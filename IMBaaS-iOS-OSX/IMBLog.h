//
//  IMBLog.h
//  IMBaaS
//
//  Created by iMokhles on 03/08/2017.
//  Copyright © 2017 iMokhles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBEnums.h"

typedef uint8_t IMBLoggingTag;

@interface IMBLog : NSObject

@property (atomic, assign) IMBLogLevel logLevel;

+ (instancetype)sharedLogger;

- (void)logMessageWithLevel:(IMBLogLevel)level
                        tag:(IMBLoggingTag)tag
                     format:(NSString *)format, ... NS_FORMAT_FUNCTION(3, 4);
@end

static const IMBLoggingTag IMBLoggingTagCommon = 0;
static const IMBLoggingTag IMBLoggingTagCrashReporting = 100;

#define IMBLog(level, loggingTag, frmt, ...) \
[[IMBLog sharedLogger] logMessageWithLevel:level tag:loggingTag format:(frmt), ##__VA_ARGS__]

#define IMBLogError(tag, frmt, ...) \
IMBLog(IMBLogLevelError, (tag), (frmt), ##__VA_ARGS__)

#define IMBLogWarning(tag, frmt, ...) \
IMBLog(IMBLogLevelWarning, (tag), (frmt), ##__VA_ARGS__)

#define IMBLogInfo(tag, frmt, ...) \
IMBLog(IMBLogLevelInfo, (tag), (frmt), ##__VA_ARGS__)

#define IMBLogDebug(tag, frmt, ...) \
IMBLog(IMBLogLevelDebug, (tag), (frmt), ##__VA_ARGS__)

#define IMBLogException(exception) \
IMBLogError(IMBLoggingTagCommon, @"Caught \"%@\" with reason \"%@\"%@", \
exception.name, exception, \
[exception callStackSymbols] ? [NSString stringWithFormat:@":\n%@.", [exception callStackSymbols]] : @"")

