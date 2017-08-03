//
//  IMBUser.h
//  IMBaaS-iOS-OSX
//
//  Created by iMokhles on 03/08/2017.
//  Copyright © 2017 iMokhles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBHeader.h"

@interface IMBUser : NSObject

@property (nonatomic, strong) NSDictionary *signupInfo;

+ (instancetype)currentUser;

+ (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password withCompletion:(IMBCompletionWithUserBlock)compeltion;
;
+ (void)signupWithCompletion:(IMBCompletionWithUserBlock)compeltion;


@end
