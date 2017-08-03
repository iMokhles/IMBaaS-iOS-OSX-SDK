//
//  IMBConfig.m
//  IMBaaS
//
//  Created by iMokhles on 03/08/2017.
//  Copyright © 2017 iMokhles. All rights reserved.
//

#import "IMBConfig.h"
#import "IMBApplication.h"

NSString *const _IMBDefaultServerURLString = @"https://imbaas.com/api/v1";

@interface IMBConfig () <IMBMutableConfig>
@property (nullable, nonatomic, copy, readwrite) NSString *applicationId;
//@property (nullable, nonatomic, copy, readwrite) NSString *clientKey;
@property (nonatomic, copy, readwrite) NSString *server;

- (instancetype)initEmpty NS_DESIGNATED_INITIALIZER;

@end

@implementation IMBConfig

+ (instancetype)emptyConfiguration {
    return [[super alloc] initEmpty];
}

- (instancetype)initEmpty {
    self = [super init];
    if (!self) return nil;
    
    _server = [_IMBDefaultServerURLString copy];
    
    return self;
}

- (instancetype)initWithBlock:(void (^)(id<IMBMutableConfig>))configurationBlock {
    self = [self initEmpty];
    if (!self) return nil;
    
    configurationBlock(self);
    
    do {
        if (!(self.applicationId.length)) {
            [NSException raise:NSInternalInconsistencyException
                        format:@"`applicationId` should not be nil."];
        }
    } while(0);
    
    return self;
}

+ (instancetype)configurationWithBlock:(void (^)(id<IMBMutableConfig>))configurationBlock {
    return [[self alloc] initWithBlock:configurationBlock];
}
- (void)setApplicationId:(NSString *)applicationId {
    do {
        if (!(applicationId.length)) {
            [NSException raise:NSInvalidArgumentException
                        format:@"'applicationId' should not be nil."];
        }
    } while(0);
    _applicationId = [applicationId copy];
}

//- (void)setClientKey:(NSString *)clientKey {
//    _clientKey = [clientKey copy];
//}

- (void)setServer:(NSString *)server {
    do {
        if (!(server.length)) {
            [NSException raise:NSInvalidArgumentException
                        format:@"Server should not be `nil`."];
        }
    } while(0);
    do {
        if (!([NSURL URLWithString:server])) {
            [NSException raise:NSInvalidArgumentException
                        format:@"Server should be a valid URL."];
        }
    } while(0);
    _server = [server copy];
}
- (instancetype)copyWithZone:(NSZone *)zone {
    return [IMBConfig configurationWithBlock:^(IMBConfig *configuration) {
        configuration->_applicationId = [self->_applicationId copy];
//        configuration->_clientKey = [self->_clientKey copy];
        configuration->_server = [self.server copy];
    }];
}
@end
