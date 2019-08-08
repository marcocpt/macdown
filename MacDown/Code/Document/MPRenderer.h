//
//  MPRenderer.h
//  MacDown
//
//  Created by Tzu-ping Chung  on 26/6.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MPRendererDataSource;
@protocol MPRendererDelegate;

/** 预览中代码块小部件的类型 */
typedef NS_ENUM(NSUInteger, MPCodeBlockAccessoryType)
{
    MPCodeBlockAccessoryNone = 0,       /**< 预览中代码块小部件 无 */
    MPCodeBlockAccessoryLanguageName,   /**< 预览中代码块小部件 显示语言名 */
    MPCodeBlockAccessoryCustom,         /**< 预览中代码块小部件 自定义 */
};


@interface MPRenderer : NSObject

@property (nonatomic) int rendererFlags;                /**< 渲染器的扩展标志位，根据设置中的配置来设置 */
@property (weak) id<MPRendererDataSource> dataSource;
@property (weak) id<MPRendererDelegate> delegate;

- (void)parseAndRenderNow;
- (void)parseAndRenderLater;

/** ✅ 如果配置改变就执行 parseMarkdown: 来解析正文。将解析得到的 html 保存在渲染器的 currentHtml 属性中 */
- (void)parseIfPreferencesChanged;

/** ✅ 如果配置改变就执行 render: */
- (void)renderIfPreferencesChanged;
- (void)render;

- (NSString *)currentHtml;
- (NSString *)HTMLForExportWithStyles:(BOOL)withStyles
                         highlighting:(BOOL)withHighlighting;

@end


@protocol MPRendererDataSource <NSObject>

/** ✅  A Boolean that indicates whether the web view is loading content. */
- (BOOL)rendererLoading;

/** ✅  编辑视图中的原始文本 */
- (NSString *)rendererMarkdown:(MPRenderer *)renderer;

/** ✅  HTML渲染器的标题 */
- (NSString *)rendererHTMLTitle:(MPRenderer *)renderer;

@end

@protocol MPRendererDelegate <NSObject>

/** ✅ 获取配置中的 extensionFlags ，包括编辑和预览设置中的扩展语法设置*/
- (int)rendererExtensions:(MPRenderer *)renderer;

/** ✅ Converts " or ' to left or right quote。Markdown 设置中：“Smartpants” */
- (BOOL)rendererHasSmartyPants:(MPRenderer *)renderer;

/** ✅ 监测 TOC 元素。Rendering 设置中：“Detect table of contents token” */
- (BOOL)rendererRendersTOC:(MPRenderer *)renderer;

/** ✅ 获取配置中的 htmlStyleName */
- (NSString *)rendererStyleName:(MPRenderer *)renderer;

/** ✅ 支持Jekyll front-matter(放在文件开头)。Rendering 设置中：“Detect Jekyll front-matter” */
- (BOOL)rendererDetectsFrontMatter:(MPRenderer *)renderer;

/** ✅ 语法高亮代码块。Rendering 设置中：“Syntax highlighted code block” */
- (BOOL)rendererHasSyntaxHighlighting:(MPRenderer *)renderer;

/** ✅ 代码块支持Mermaid(Graph Visualization)。Rendering 设置中：“Mermaid”。*/
- (BOOL)rendererHasMermaid:(MPRenderer *)renderer;

/** ✅ 代码块支持Graphviz(Graph Visualization)。Rendering 设置中：“Graphviz”。 */
- (BOOL)rendererHasGraphviz:(MPRenderer *)renderer;

/** ✅ 预览中的代码块附件，在右上角显示，由 MPCodeBlockAccessoryType 定义。Rendering 设置中：Accessory 选择 */
- (MPCodeBlockAccessoryType)rendererCodeBlockAccesory:(MPRenderer *)renderer;

/** ✅ 代码块支持MathJax。Rendering 设置中：“TeX-like math syntax” */
- (BOOL)rendererHasMathJax:(MPRenderer *)renderer;

/** ✅ 获取配置中的 htmlHighlightingThemeName */
- (NSString *)rendererHighlightingThemeName:(MPRenderer *)renderer;

/** ✅ 使用已渲染的 html 文本在预览视图中显示。当前未实现局部替换 */
- (void)renderer:(MPRenderer *)renderer didProduceHTMLOutput:(NSString *)html;

@end
