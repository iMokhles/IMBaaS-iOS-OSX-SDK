//
//  IMBConfig.h
//  IMBaaS
//
//  Created by iMokhles on 03/08/2017.
//  Copyright © 2017 iMokhles. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IMBMutableConfig <NSObject>
@property (nullable, nonatomic, copy) NSString *applicationId;
// client id will be available later ( if needed )
//@property (nullable, nonatomic, copy) NSString *clientKey;
@property (nonatomic, copy) NSString *server;
@end

@interface IMBConfig : NSObject <NSCopying>

@property (nullable, nonatomic, copy, readonly) NSString *applicationId;
// client id will be available later ( if needed )
//@property (nullable, nonatomic, copy, readonly) NSString *clientKey;
@property (nonatomic, copy, readonly) NSString *server;

+ (instancetype)configurationWithBlock:(void (^)(id<IMBMutableConfig> configuration))configurationBlock;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
