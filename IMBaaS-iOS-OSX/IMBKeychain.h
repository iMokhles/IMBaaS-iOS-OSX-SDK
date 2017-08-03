//
//  IMBKeychain.h
//  IMBaaS
//
//  Created by iMokhles on 03/08/2017.
//  Copyright © 2017 iMokhles. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const IMBKeychainStoreDefaultService;

@interface IMBKeychain : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithService:(NSString *)service NS_DESIGNATED_INITIALIZER;

- (nullable id)objectForKey:(NSString *)key;
- (nullable id)objectForKeyedSubscript:(NSString *)key;

- (BOOL)setObject:(nullable id)object forKey:(NSString *)key;
- (BOOL)setObject:(nullable id)object forKeyedSubscript:(NSString *)key;
- (BOOL)removeObjectForKey:(NSString *)key;
- (BOOL)removeAllObjects;

@end

NS_ASSUME_NONNULL_END
