//
//  MPPlugInController.m
//  MacDown
//
//  Created by Tzu-ping Chung on 02/3.
//  Copyright © 2016 Tzu-ping Chung . All rights reserved.
//

#import "NSString+Lookup.h"
#import "MPPlugIn.h"
#import "MPPlugInController.h"
#import "MPUtilities.h"


@implementation MPPlugInController
/** ✅ 初始化所有插件。调用所有插件的 plugInDidInitialize 方法 */
- (instancetype)init
{
    self = [super init];
    if (!self)
        return nil;

    id q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(q, ^{
        for (MPPlugIn *plugin in [self buildPlugIns])
            [plugin plugInDidInitialize];
    });
    return self;
}


#pragma mark - NSMenuDelegate
/// ✅ NSMenuDelegate: 更新插件菜单（在 nib 文件中设置了菜单目录的代理为 self ），为插件菜单添加调用方法 `invokePlugIn:`，并把 MPPlugIn 对象存储在菜单的 representedObject 属性中。
- (void)menuNeedsUpdate:(NSMenu *)menu
{
    [menu removeAllItems];
    for (MPPlugIn *plugin in [self buildPlugIns])
    {
        NSMenuItem *item = [menu addItemWithTitle:plugin.name
                                           action:@selector(invokePlugIn:)
                                    keyEquivalent:@""];
        item.target = self;
        item.representedObject = plugin;
    }
}


#pragma mark - Private
/// ✅ 点击插件菜单栏执行的方法。调用插件的 run 函数
- (void)invokePlugIn:(NSMenuItem *)item
{
    // 创建菜单时设置了“item.representedObject = plugin”
    MPPlugIn *plugin = item.representedObject;
    if (![plugin run:item])
        NSLog(@"Failed to run plugin %@", plugin.name);
}

/** ✅ 获取应用根目录下的 kMPPlugInsDirectoryName 中的插件 */
- (NSArray<MPPlugIn *> *)buildPlugIns
{
    NSArray *paths = MPListEntriesForDirectory(kMPPlugInsDirectoryName, nil);
    NSMutableArray *plugins = [NSMutableArray arrayWithCapacity:paths.count];
    for (NSString *path in paths)
    {
        if (![path hasExtension:kMPPlugInFileExtension])
            continue;
        NSBundle *bundle = [NSBundle bundleWithPath:path];
        MPPlugIn *plugin = [[MPPlugIn alloc] initWithBundle:bundle];
        if (!plugin)
            continue;
        [plugins addObject:plugin];
    }
    return [plugins copy];
}

@end
