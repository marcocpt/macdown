//
//  DOMNode+Text.m
//  MacDown
//
//  Created by Tzu-ping Chung on 18/1.
//  Copyright (c) 2015 Tzu-ping Chung . All rights reserved.
//

#import "DOMNode+Text.h"
/// ✅ 统计那种类型 DOMNode 的文本数
typedef NS_ENUM(NSUInteger, DOMNodeTextCountingOption)
{
    DOMNodeTextCountWords,
    DOMNodeTextCountCharacters,
    DOMNodeTextCountCharactersWithoutWhiteSpaces,
};

NS_INLINE NSUInteger MPGetNodeTextCount(DOMNode *, DOMNodeTextCountingOption);

@implementation NSString (WordCount)

- (NSUInteger)numberOfWords
{
    __block NSUInteger count = 0;
    NSStringEnumerationOptions options =
    NSStringEnumerationByWords | NSStringEnumerationSubstringNotRequired;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:options usingBlock:
     ^(NSString *str, NSRange strRange, NSRange enclosingRange, BOOL *stop) {
         count++;
     }];
    return count;
}

- (NSUInteger)lengthWithoutNewlines
{
    static NSCharacterSet *sp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sp = [NSCharacterSet newlineCharacterSet];
    });

    NSUInteger length = 0;
    for (NSString *comp in [self componentsSeparatedByCharactersInSet:sp])
        length += comp.length;
    return length;
}


- (NSUInteger)lengthWithoutWhitespacesAndNewlines
{
    static NSCharacterSet *sp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sp = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    });

    NSUInteger length = 0;
    for (NSString *comp in [self componentsSeparatedByCharactersInSet:sp])
        length += comp.length;
    return length;
}

@end

/// ✅ 获取子节点文本数
NS_INLINE NSUInteger MPGetChildrenNodetextCount(
    DOMNode *node, DOMNodeTextCountingOption opt)
{
    NSUInteger count = 0;
    for (DOMNode *c = node.firstChild; c; c = c.nextSibling)
        count += MPGetNodeTextCount(c, opt);
    return count;
}

/// ✅ 依据 opt 来统计节点文本数
NS_INLINE NSUInteger MPGetNodeTextCount(
    DOMNode *node, DOMNodeTextCountingOption opt)
{
    switch (node.nodeType)
    {
        case 1:     // Node.ELEMENT_NODE
        case 9:     // Node.DOCUMENT_NODE
        case 11:    // Node.DOCUMENT_FRAGMENT_NODE
            if ([node respondsToSelector:@selector(tagName)])
            {
                NSString *tagName = [(id)node tagName].uppercaseString;
                if ([tagName isEqualToString:@"SCRIPT"]
                        || [tagName isEqualToString:@"STYLE"]
                        || [tagName isEqualToString:@"HEAD"])
                    return 0;
                if (opt == DOMNodeTextCountWords
                    && [tagName isEqualToString:@"CODE"])
                {
                    // A PRE-CODE combo, i.e. a code block. Exclude.
                    if ([node.parentElement.tagName isEqualToString:@"PRE"])
                        return 0;
                    // An inline code counts as ONE word if it has content.
                    return MPGetChildrenNodetextCount(node, opt) ? 1 : 0;
                }
            }
            return MPGetChildrenNodetextCount(node, opt);
        case 3:     // Node.TEXT_NODE
        case 4:     // Node.CDATA_SECTION_NODE
            switch (opt)
            {
                case DOMNodeTextCountWords:
                    return node.nodeValue.numberOfWords;
                case DOMNodeTextCountCharacters:
                    return node.nodeValue.lengthWithoutNewlines;
                case DOMNodeTextCountCharactersWithoutWhiteSpaces:
                    return node.nodeValue.lengthWithoutWhitespacesAndNewlines;
            }
        default:
            break;
    }
    return 0;
}


@implementation DOMNode (Text)
// ✅
- (DOMNodeTextCount)textCount
{
    DOMNodeTextCount count;
    count.words = MPGetNodeTextCount(self, DOMNodeTextCountWords);
    count.characters = MPGetNodeTextCount(self, DOMNodeTextCountCharacters);
    count.characterWithoutSpaces =
        MPGetNodeTextCount(self, DOMNodeTextCountCharactersWithoutWhiteSpaces);
    return count;
}

@end
