//
//  MPAsset.m
//  MacDown
//
//  Created by Tzu-ping Chung  on 29/6.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import "MPAsset.h"
#import <HBHandlebars/HBHandlebars.h>
#import "MPUtilities.h"


NSString * const kMPPlainType = @"text/plain";
NSString * const kMPCSSType = @"text/css";
NSString * const kMPJavaScriptType = @"text/javascript";
NSString * const kMPMathJaxConfigType = @"text/x-mathjax-config";


@interface MPAsset ()
@property (strong) NSURL *url;                    /**< 资源文件的 url 路径 */
@property (copy, nonatomic) NSString *typeName;   /**< 资源文件的类型名，当类型名为空时，会设置为默认类型名 */
@property (readonly) NSString *defaultTypeName;   /**< 资源文件默认的类型名 kMPPlainType */
@end


@implementation MPAsset
/** 返回类型名，如果为空就返回默认的类型名 */
- (NSString *)typeName
{
    return _typeName ? _typeName : self.defaultTypeName;
}
/** 返回默认的类型名 */
- (NSString *)defaultTypeName
{
    return kMPPlainType;
}

/** 使用 url 和 typeName 初始化 MPAsset */
+ (instancetype)assetWithURL:(NSURL *)url andType:(NSString *)typeName
{
    return [[self alloc] initWithURL:url andType:typeName];
}
/** 使用 url 和 typeName 初始化 MPAsset */
- (instancetype)initWithURL:(NSURL *)url andType:(NSString *)typeName
{
    self = [super init];
    if (!self)
        return nil;
    self.url = [url copy];
    self.typeName = typeName;
    return self;
}
/** override：初始化 ,url 和 type 均为 nil */
- (instancetype)init
{
    return [self initWithURL:nil andType:nil];
}
/** 产生 MPAssetOption 的 Handlebars 模板， 子类必须覆盖此方法*/
- (NSString *)templateForOption:(MPAssetOption)option
{
    // `_cmd` 在 Objective-C 的方法中表示当前方法的 selector
    // 参考：https://www.jianshu.com/p/fdb1bc445266
    NSString *reason =
        [NSString stringWithFormat:@"Method %@ requires overriding",
                                   NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason userInfo:nil];
}
/** 依据 option 生成上下文，并调用 templateForOption: 方法生成模板文件，最后使用 HBHandlebars 解析模板 */
- (NSString *)htmlForOption:(MPAssetOption)option
{
    NSMutableDictionary *context =
        [NSMutableDictionary dictionaryWithObject:self.typeName
                                           forKey:@"typeName"];
    switch (option)
    {
        case MPAssetNone:
            break;
        case MPAssetEmbedded:
            if (self.url.isFileURL)
            {
                NSString *content = MPReadFileOfPath(self.url.path);
                if ([content hasSuffix:@"\n"])
                    content = [content substringToIndex:content.length - 1];
                context[@"content"] = content;
                break;
            }
            // Non-file URLs fallthrough to be treated as full links.
        case MPAssetFullLink:
            context[@"url"] = self.url.absoluteString;
            break;
    }

    NSString *template = [self templateForOption:option];
    if (!template || !context.count)
        return nil;

    NSString *result = [HBHandlebars renderTemplateString:template
                                              withContext:context error:NULL];

    return result;
}

@end


@implementation MPStyleSheet
/** 返回默认类型名 */
- (NSString *)defaultTypeName
{
    return kMPCSSType;
}
/** 调用父类的初始化方法，使用 url 和 kMPCSSType 初始化 MPAsset */
+ (instancetype)CSSWithURL:(NSURL *)url
{
    return [super assetWithURL:url andType:kMPCSSType];
}
/** 产生 MPAssetOption 的 handlebars 模板 */
- (NSString *)templateForOption:(MPAssetOption)option
{
    NSString *template = nil;
    switch (option)
    {
        case MPAssetNone:
            break;
        case MPAssetEmbedded:
            if (self.url.isFileURL)
            {
                template = (@"<style type=\"{{ typeName }}\">\n"
                            @"{{{ content }}}\n</style>");
                break;
            }
            // Non-file URLs fallthrough to be treated as full links.
        case MPAssetFullLink:
            template = (@"<link rel=\"stylesheet\" type=\"{{ typeName }}\" "
                        @"href=\"{{ url }}\">");
            break;
    }
    return template;
}

@end


@implementation MPScript
/** 返回默认类型名 */
- (NSString *)defaultTypeName
{
    return kMPJavaScriptType;
}
/** 调用父类的初始化方法，使用 url 和 kMPJavaScriptType 初始化 MPScript */
+ (instancetype)javaScriptWithURL:(NSURL *)url
{
    return [super assetWithURL:url andType:kMPJavaScriptType];
}
/** 产生 MPAssetOption 的 handlebars 模板 */
- (NSString *)templateForOption:(MPAssetOption)option
{
    NSString *template = nil;
    switch (option)
    {
        case MPAssetNone:
            break;
        case MPAssetEmbedded:
            if (self.url.isFileURL)
            {
                template = (@"<script type=\"{{ typeName }}\">\n"
                            @"{{{ content }}}\n</script>");
                break;
            }
            // Non-file URLs fall-through to be treated as full links.
        case MPAssetFullLink:
            template = (@"<script type=\"{{ typeName }}\" src=\"{{ url }}\">"
                        @"</script>");
            break;
    }
    return template;
}

@end


@implementation MPEmbeddedScript
/** 如果是 MPAssetFullLink，将它转换为 MPAssetEmbedded 后再调用父类方法。*/
- (NSString *)htmlForOption:(MPAssetOption)option
{
    if (option == MPAssetFullLink)
        option = MPAssetEmbedded;
    return [super htmlForOption:option];
}

@end
