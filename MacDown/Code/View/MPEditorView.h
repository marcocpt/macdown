//
//  MPEditorView.h
//  MacDown
//
//  Created by Tzu-ping Chung  on 30/8.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MPEditorView : NSTextView

@property BOOL scrollsPastEnd;  /**< ✅ 滚动可超过文档底部。Editor 设置中："Scroll past end"。 */
- (NSRect)contentRect;          /**< ✅ 如果 _contentRect 等于 NSZeroRect，就返回 self.frame，否则返回 _contentRect */

@end
