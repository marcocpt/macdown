//
//  MPAsset.h
//  MacDown
//
//  Created by Tzu-ping Chung  on 29/6.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import <Foundation/Foundation.h>


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
+ (instancetype)assetWithURL:(NSURL *)url andType:(NSString *)typeName;
- (instancetype)initWithURL:(NSURL *)url andType:(NSString *)typeName;
- (NSString *)htmlForOption:(MPAssetOption)option;
@end


@interface MPStyleSheet : MPAsset
+ (instancetype)CSSWithURL:(NSURL *)url;
@end


@interface MPScript : MPAsset
+ (instancetype)javaScriptWithURL:(NSURL *)url;
@end


@interface MPEmbeddedScript : MPScript
@end
