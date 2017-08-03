//
//  IMBApplication.m
//  IMBaaS
//
//  Created by iMokhles on 03/08/2017.
//  Copyright © 2017 iMokhles. All rights reserved.
//

#import "IMBApplication.h"
#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#elif PF_TARGET_OS_OSX
#import <AppKit/AppKit.h>
#endif


@implementation IMBApplication

///--------------------------------------
#pragma mark - Init
///--------------------------------------

+ (instancetype)currentApplication {
    static IMBApplication *application;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        application = [[self alloc] init];
    });
    return application;
}

- (BOOL)isAppStoreEnvironment {
#if TARGET_OS_IOS && !TARGET_IPHONE_SIMULATOR
    return ([[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"] == nil);
#endif
    
    return NO;
}

- (BOOL)isExtensionEnvironment {
    return [[NSBundle mainBundle].bundlePath hasSuffix:@".appex"];
}

- (NSInteger)iconBadgeNumber {
#if TARGET_OS_WATCH || TARGET_OS_TV
    return 0;
#elif TARGET_OS_IOS
    return self.systemApplication.applicationIconBadgeNumber;
#elif PF_TARGET_OS_OSX
    // Make sure not to use `NSApp` here, because it doesn't work sometimes,
    // `NSApplication +sharedApplication` does though.
    NSString *badgeLabel = [[NSApplication sharedApplication] dockTile].badgeLabel;
    if (badgeLabel.length == 0) {
        return 0;
    }
    
    NSScanner *scanner = [NSScanner localizedScannerWithString:badgeLabel];
    
    NSInteger number = 0;
    [scanner scanInteger:&number];
    if (scanner.scanLocation != badgeLabel.length) {
        return 0;
    }
    
    return number;
#endif
}

- (void)setIconBadgeNumber:(NSInteger)iconBadgeNumber {
    if (self.iconBadgeNumber != iconBadgeNumber) {
#if TARGET_OS_IOS
        self.systemApplication.applicationIconBadgeNumber = iconBadgeNumber;
#elif PF_TARGET_OS_OSX
        [[NSApplication sharedApplication] dockTile].badgeLabel = [@(iconBadgeNumber) stringValue];
#endif
    }
}

- (UIApplication *)systemApplication {
#if TARGET_OS_WATCH
    return nil;
#else
    // Workaround to make `sharedApplication` still be called even if compiling for App Extensions or WatchKit apps.
    return [UIApplication performSelector:@selector(sharedApplication)];
#endif
}
@end
