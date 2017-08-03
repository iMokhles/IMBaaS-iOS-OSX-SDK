//
//  IMBRequest.m
//  IMBaaS
//
//  Created by iMokhles on 03/08/2017.
//  Copyright © 2017 iMokhles. All rights reserved.
//

#import "IMBRequest.h"
#import "IMBHeader.h"

static NSString *const IMBHTTPURLRequestContentTypeJSON = @"application/json; charset=utf-8";

@implementation IMBRequest

+ (NSMutableURLRequest *)urlRequestWithURL:(NSURL *)url
                                httpMethod:(NSString *)httpMethod
                               httpHeaders:(NSDictionary *)httpHeaders
                                parameters:(NSDictionary *)parameters {
    NSParameterAssert(url != nil);
    NSParameterAssert(httpMethod != nil);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = httpMethod;
    request.allHTTPHeaderFields = httpHeaders;
    
    if (parameters != nil) {
        do {
            if (!([httpMethod isEqualToString:IMBHTTPRequestMethodPOST] ||
                  [httpMethod isEqualToString:IMBHTTPRequestMethodPUT])) {
                [NSException raise:NSInternalInconsistencyException
                            format:@"Can't create %@ request with json body.", httpMethod];
            }
        } while(0);
        
        [request setValue:IMBHTTPURLRequestContentTypeJSON forHTTPHeaderField:IMBHTTPRequestHeaderNameContentType];
        
        NSError *error = nil;
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters
                                                           options:(NSJSONWritingOptions)0
                                                             error:&error];
        
        do {
            if (!(error == nil)) {
                [NSException raise:NSInternalInconsistencyException
                            format:@"Failed to serialize JSON with error = %@", error];
            }
        } while(0);
    }
    return request;
}


@end
