//
//  NSString+Lookup.h
//  MacDown
//
//  Created by Tzu-ping Chung  on 11/06/2014.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Lookup)

- (NSInteger)locationOfFirstNewlineBefore:(NSUInteger)location;
- (NSUInteger)locationOfFirstNewlineAfter:(NSUInteger)location;
- (NSUInteger)locationOfFirstNonWhitespaceCharacterInLineBefore:(NSUInteger)loc;

- (NSArray *)matchesForPattern:(NSString *)pattern;

/** ✅ 找到 Jekyll front-matter，计数出偏移的位置并用 YAMLSerialization 解析 */
- (id)frontMatter:(NSUInteger *)contentOffset;
- (NSString *)titleString;

- (BOOL)hasExtension:(NSString *)extension;

@end
