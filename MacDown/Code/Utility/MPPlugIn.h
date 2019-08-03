//
//  MPPlugIn.h
//  MacDown
//
//  Created by Tzu-ping Chung on 02/3.
//  Copyright © 2016 Tzu-ping Chung . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDOcument.h"

@interface MPPlugIn : NSObject

@property (nonatomic, readonly) NSString *name;     /**< 插件的名称，用于在菜单栏显示 */

- (instancetype)initWithBundle:(NSBundle *)bundle;
- (BOOL)run:(id)sender;

- (void)plugInDidInitialize;

@end
