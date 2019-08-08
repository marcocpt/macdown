//
//  MPAsset.h
//  MacDown
//
//  Created by Tzu-ping Chung  on 29/6.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import <Foundation/Foundation.h>

/// 资源类型
typedef NS_ENUM(NSInteger, MPAssetOption)
{
    MPAssetNone,        /**< 空资源 */
    MPAssetEmbedded,    /**< 内嵌资源，导出为 HTML 格式文件时会指定此类型，MPEmbeddedScript 中也指定此类型 */
    MPAssetFullLink,    /**< 完整的链接 */
};

extern NSString * const kMPCSSType;
extern NSString * const kMPJavaScriptType;
extern NSString * const kMPMathJaxConfigType;


@interface MPAsset : NSObject
/** ✅ 使用 url 和 typeName 初始化 MPAsset */
+ (instancetype)assetWithURL:(NSURL *)url andType:(NSString *)typeName;

/** ✅ 使用 url 和 typeName 初始化 MPAsset */
- (instancetype)initWithURL:(NSURL *)url andType:(NSString *)typeName;

/** ✅ 依据 option 生成上下文，并调用 templateForOption: 方法生成模板文件，最后使用 HBHandlebars 解析模板 */
- (NSString *)htmlForOption:(MPAssetOption)option;
@end


@interface MPStyleSheet : MPAsset

/** ✅ 调用父类的初始化方法，使用 url 和 kMPCSSType 初始化 MPAsset */
+ (instancetype)CSSWithURL:(NSURL *)url;
@end


@interface MPScript : MPAsset
/** ✅ 调用父类的初始化方法，使用 url 和 kMPJavaScriptType 初始化 MPScript */
+ (instancetype)javaScriptWithURL:(NSURL *)url;
@end


@interface MPEmbeddedScript : MPScript
@end
