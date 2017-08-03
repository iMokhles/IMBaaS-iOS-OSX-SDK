//
//  IMBHeader.h
//  IMBaaS-iOS-OSX
//
//  Created by iMokhles on 03/08/2017.
//  Copyright © 2017 iMokhles. All rights reserved.
//

#ifndef IMBHeader_h
#define IMBHeader_h

#import <Foundation/Foundation.h>

@class IMBUser;

typedef void (^IMBCompletionWithUserBlock)(BOOL succeeded, NSError *error, IMBUser *user);
typedef void (^IMBCompletionWithObjectBlock)(BOOL succeeded, NSError *error, id object);
typedef void (^IMBCompletionWithArrayBlock)(BOOL succeeded, NSError *error, NSArray *objects);


static NSString *const IMBHTTPRequestMethodGET = @"GET";
static NSString *const IMBHTTPRequestMethodHEAD = @"HEAD";
static NSString *const IMBHTTPRequestMethodDELETE = @"DELETE";
static NSString *const IMBHTTPRequestMethodPOST = @"POST";
static NSString *const IMBHTTPRequestMethodPUT = @"PUT";

static NSString *const IMBHTTPRequestHeaderNameContentType = @"Content-Type";
static NSString *const IMBHTTPRequestHeaderNameContentLength = @"Content-Length";

#endif /* IMBHeader_h */
