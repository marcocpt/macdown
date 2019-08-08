//
//  MPUtilities.h
//  MacDown
//
//  Created by Tzu-ping Chung  on 8/06/2014.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kMPStylesDirectoryName;
extern NSString * const kMPStyleFileExtension;
extern NSString * const kMPThemesDirectoryName;
extern NSString * const kMPThemeFileExtension;
extern NSString * const kMPPlugInsDirectoryName;
extern NSString * const kMPPlugInFileExtension;

NSString *MPDataDirectory(NSString *relativePath);
NSString *MPPathToDataFile(NSString *name, NSString *dirPath);

/** ✅ 获取 dirName 目录中的文件路径，如果 processor 不为空，则使用 processor 处理获得的路径 */
NSArray *MPListEntriesForDirectory(
    NSString *dirName, NSString *(^processor)(NSString *absolutePath)
);

// Block factory for MPListEntriesForDirectory
NSString *(^MPFileNameHasExtensionProcessor(NSString *ext))(NSString *path);

BOOL MPCharacterIsWhitespace(unichar character);
BOOL MPCharacterIsNewline(unichar character);
BOOL MPStringIsNewline(NSString *str);

/** ✅ 指定文件名 name 的 style 文件的路径 */
NSString *MPStylePathForName(NSString *name);

/** ✅ 指定文件名 name 的主题文件的路径 */
NSString *MPThemePathForName(NSString *name);

/** ✅ 指定文件名 name 的语法高亮主题路径 */
NSURL *MPHighlightingThemeURLForName(NSString *name);

/** ✅ 读取指定路径的文件内容，如果出错就返回空串 */
NSString *MPReadFileOfPath(NSString *path);

/** ✅ 获取包中 .map 格式的解包数据 */
NSDictionary *MPGetDataMap(NSString *name);

id MPGetObjectFromJavaScript(NSString *code, NSString *variableName);


static void (^MPDocumentOpenCompletionEmpty)(
        NSDocument *doc, BOOL wasOpen, NSError *error) = ^(
        NSDocument *doc, BOOL wasOpen, NSError *error) {

};
