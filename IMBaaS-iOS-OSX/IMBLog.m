//
//  IMBLog.m
//  IMBaaS
//
//  Created by iMokhles on 03/08/2017.
//  Copyright © 2017 iMokhles. All rights reserved.
//

#import "IMBLog.h"
#import "IMBApplication.h"
@implementation IMBLog

+ (NSString *)_descriptionForLoggingTag:(IMBLoggingTag)tag {
    NSString *description = nil;
    switch (tag) {
        case IMBLoggingTagCommon:
            break;
        case IMBLoggingTagCrashReporting:
            description = @"Crash Reporting";
            break;
        default:
            break;
    }
    return description;
}

+ (NSString *)_descriptionForLogLevel:(IMBLogLevel)logLevel {
    NSString *description = nil;
    switch (logLevel) {
        case IMBLogLevelNone:
            break;
        case IMBLogLevelDebug:
            description = @"Debug";
            break;
        case IMBLogLevelError:
            description = @"Error";
            break;
        case IMBLogLevelWarning:
            description = @"Warning";
            break;
        case IMBLogLevelInfo:
            description = @"Info";
            break;
    }
    return description;
}

+ (instancetype)sharedLogger {
    static IMBLog *logger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logger = [[IMBLog alloc] init];
    });
    return logger;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _logLevel = ([IMBApplication currentApplication].appStoreEnvironment ? IMBLogLevelNone : IMBLogLevelWarning);
    
    return self;
}

- (void)logMessageWithLevel:(IMBLogLevel)level
                        tag:(IMBLoggingTag)tag
                     format:(NSString *)format, ... NS_FORMAT_FUNCTION(3, 4) {
    if (level > self.logLevel || level == IMBLogLevelNone || !format) {
        return;
    }
    
    va_list args;
    va_start(args, format);
    
    NSMutableString *message = [NSMutableString stringWithFormat:@"[%@]", [[self class] _descriptionForLogLevel:level]];
    
    NSString *tagDescription = [[self class] _descriptionForLoggingTag:tag];
    if (tagDescription) {
        [message appendFormat:@"[%@]", tagDescription];
    }
    
    [message appendFormat:@": %@", format];
    
    NSLogv(message, args);
    
    va_end(args);
}

@end
