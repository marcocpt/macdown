//
//  DOMNode+Text.h
//  MacDown
//
//  Created by Tzu-ping Chung on 18/1.
//  Copyright (c) 2015 Tzu-ping Chung . All rights reserved.
//

#import <WebKit/WebKit.h>
/// ✅ 记录 DOM 节点的单词、字符、非空字符的个数
struct DOMNodeTextCount
{
    NSUInteger words;
    NSUInteger characters;
    NSUInteger characterWithoutSpaces;
};

typedef struct DOMNodeTextCount DOMNodeTextCount;


@interface DOMNode (Text)
/// ✅ 获取 DOM 节点的文本数统计。
@property (readonly, nonatomic) DOMNodeTextCount textCount;

@end
