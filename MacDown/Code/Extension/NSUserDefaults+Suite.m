//
//  NSUserDefaults+Suite.m
//  MacDown
//
//  Created by Tzu-ping Chung on 19/11.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import "NSUserDefaults+Suite.h"

@implementation NSUserDefaults (Suite)

/// ✅ 命令行工具中使用
- (instancetype)initWithSuiteNamed:(NSString *)suiteName
{
    self = [self init];
    if (!self)
        return nil;
    [self addSuiteNamed:suiteName];
    return self;
}

/** ✅ 调用 CFPreferencesCopyValue 来获取给定域中 plist 文件中配置的值。
 命令行查看：`$ defaults read com.uranusjr.macdown`
 */
- (id)objectForKey:(NSString *)key inSuiteNamed:(NSString *)suiteName
{
    id value = (__bridge id)CFPreferencesCopyValue(
                           (__bridge CFStringRef)key,
                           (__bridge CFStringRef)suiteName,
                           kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    return value;
}

/** ✅ 调用 CFPreferencesSetValue 来设定给定域中 plist 文件中配置的值。
 命令行设置：`$ default write com.apple.dt.Xcode IDEIndexerActivityShowNumericProgress - bool ture`
 */
- (void)setObject:(id)value forKey:(NSString *)key
     inSuiteNamed:(NSString *)suiteName
{
    CFPreferencesSetValue((__bridge CFStringRef)key,
                          (__bridge CFPropertyListRef)value,
                          (__bridge CFStringRef)suiteName,
                          kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
}

@end
