//
//  IMBApplication.h
//  IMBaaS
//
//  Created by iMokhles on 03/08/2017.
//  Copyright © 2017 iMokhles. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#elif TARGET_OS_WATCH
@class UIApplication;
#elif PF_TARGET_OS_OSX
#import <AppKit/AppKit.h>
@compatibility_alias UIApplication NSApplication;
#endif

@interface IMBApplication : NSObject

@property (nonatomic, strong, readonly) UIApplication *systemApplication;

@property (nonatomic, assign, readonly, getter=isAppStoreEnvironment) BOOL appStoreEnvironment;
@property (nonatomic, assign, readonly, getter=isExtensionEnvironment) BOOL extensionEnvironment;

@property (nonatomic, assign) NSInteger iconBadgeNumber;

+ (instancetype)currentApplication;


@end
