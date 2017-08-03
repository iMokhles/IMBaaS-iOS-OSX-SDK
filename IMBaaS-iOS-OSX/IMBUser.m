//
//  IMBUser.m
//  IMBaaS-iOS-OSX
//
//  Created by iMokhles on 03/08/2017.
//  Copyright © 2017 iMokhles. All rights reserved.
//

#import "IMBUser.h"

@implementation IMBUser

+ (IMBUser *)currentUser {
    
    return [[self alloc] init];
}

+ (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password withCompletion:(IMBCompletionWithUserBlock)compeltion {
    
}
;
+ (void)signupWithCompletion:(IMBCompletionWithUserBlock)compeltion {
    
}
@end
