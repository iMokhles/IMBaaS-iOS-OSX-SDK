//
//  IMBKeychain.m
//  IMBaaS
//
//  Created by iMokhles on 03/08/2017.
//  Copyright © 2017 iMokhles. All rights reserved.
//

#import "IMBKeychain.h"
#import "IMBLog.h"

NSString *const IMBKeychainStoreDefaultService = @"com.imokhles.imbaas.sdk";

@interface IMBKeychain () {
    dispatch_queue_t _synchronizationQueue;
}

@property (nonatomic, copy, readonly) NSString *service;
@property (nonatomic, copy, readonly) NSDictionary *keychainQueryTemplate;

@end

@implementation IMBKeychain

+ (NSDictionary *)_keychainQueryTemplateForService:(NSString *)service {
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    if (service.length) {
        query[(__bridge NSString *)kSecAttrService] = service;
    }
    query[(__bridge NSString *)kSecClass] = (__bridge id)kSecClassGenericPassword;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wtautological-pointer-compare"
    if (&kSecAttrAccessible != nil) {
        query[(__bridge id)kSecAttrAccessible] =  (__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly;
    }
#pragma clang diagnostic pop
    
    return [query copy];
}

- (instancetype)initWithService:(NSString *)service {
    self = [super init];
    if (!self) return nil;
    
    _service = service;
    _keychainQueryTemplate = [[self class] _keychainQueryTemplateForService:service];
    
    NSString *queueLabel = [NSString stringWithFormat:@"com.imokhles.imbaas.keychain.%@", service];
    _synchronizationQueue = dispatch_queue_create(queueLabel.UTF8String, DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_set_specific((_synchronizationQueue),
                                (__bridge void *)(_synchronizationQueue),
                                (__bridge void *)(_synchronizationQueue),
                                NULL);
    return self;
}
- (id)objectForKey:(NSString *)key {
    __block NSData *data = nil;
    dispatch_sync(_synchronizationQueue, ^{
        data = [self _dataForKey:key];
    });
    
    if (data) {
        id object = nil;
        @try {
            object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        @catch (NSException *exception) {
            IMBLogDebug(IMBLoggingTagCommon, @"Failed to unarchive data from keychain: %@", exception);
        }
        
        return object;
    }
    return nil;
}

- (id)objectForKeyedSubscript:(NSString *)key {
    return [self objectForKey:key];
}
- (NSData *)_dataForKey:(NSString *)key {
    NSMutableDictionary *query = [self.keychainQueryTemplate mutableCopy];
    
    query[(__bridge NSString *)kSecAttrAccount] = key;
    query[(__bridge NSString *)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    query[(__bridge NSString *)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    
    //recover data
    CFDataRef data = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&data);
    if (status != errSecSuccess && status != errSecItemNotFound) {
        IMBLogError(IMBLoggingTagCommon,
                   @"IMBKeychainStore failed to get object for key '%@', with error: %ld", key, (long)status);
    }
    return CFBridgingRelease(data);
}
- (BOOL)setObject:(id)object forKey:(NSString *)key {
    NSParameterAssert(key != nil);
    
    if (!object) {
        return [self removeObjectForKey:key];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    if (!data) {
        return NO;
    }
    
    NSMutableDictionary *query = [self.keychainQueryTemplate mutableCopy];
    query[(__bridge NSString *)kSecAttrAccount] = key;
    
    NSDictionary *update = @{ (__bridge NSString *)kSecValueData : data };
    
    __block OSStatus status = errSecSuccess;
    dispatch_barrier_sync(_synchronizationQueue,^{
        if ([self _dataForKey:key]) {
            status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)update);
        } else {
            [query addEntriesFromDictionary:update];
            status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
        }
    });
    
    if (status != errSecSuccess) {
        IMBLogError(IMBLoggingTagCommon,
                   @"IMBKeychainStore failed to set object for key '%@', with error: %ld", key, (long)status);
    }
    
    return (status == errSecSuccess);
}

- (BOOL)setObject:(id)object forKeyedSubscript:(NSString *)key {
    return [self setObject:object forKey:key];
}

- (BOOL)removeObjectForKey:(NSString *)key {
    __block BOOL value = NO;
    dispatch_barrier_sync(_synchronizationQueue, ^{
        value = [self _removeObjectForKey:key];
    });
    return value;
}

- (BOOL)_removeObjectForKey:(NSString *)key {
    do {
        void *mark = (__bridge void *)(_synchronizationQueue);
        
        do {
            if (!(dispatch_get_specific(mark) == mark)) {
                [NSException raise:NSInternalInconsistencyException
                            format:@"%s must be executed on %s",  __PRETTY_FUNCTION__, dispatch_queue_get_label(_synchronizationQueue)];
            }
        } while(0);
        
    } while (0);
        
    NSMutableDictionary *query = [self.keychainQueryTemplate mutableCopy];
    query[(__bridge NSString *)kSecAttrAccount] = key;
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    return (status == errSecSuccess);
}

- (BOOL)removeAllObjects {
    NSMutableDictionary *query = [self.keychainQueryTemplate mutableCopy];
    query[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitAll;
    
    __block BOOL value = YES;
    dispatch_barrier_sync(_synchronizationQueue, ^{
        CFArrayRef result = NULL;
        OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
        if (status != errSecSuccess) {
            return;
        }
        
        for (NSDictionary *item in CFBridgingRelease(result)) {
            NSString *key = item[(__bridge id)kSecAttrAccount];
            value = [self _removeObjectForKey:key];
            if (!value) {
                return;
            }
        }
    });
    return value;
}
@end
