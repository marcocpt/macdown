//
//  MPPlugInController.h
//  MacDown
//
//  Created by Tzu-ping Chung on 02/3.
//  Copyright © 2016 Tzu-ping Chung . All rights reserved.
//

#import <Foundation/Foundation.h>
/// 插件控制器。编写插件参考：https://github.com/MacDownApp/macdown-gistit
@interface MPPlugInController : NSObject<NSMenuDelegate>

@property (weak) IBOutlet NSDocumentController *documentController; /**< 未使用 */

@end
