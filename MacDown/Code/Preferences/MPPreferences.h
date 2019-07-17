//
//  MPPreferences.h
//  MacDown
//
//  Created by Tzu-ping Chung  on 7/06/2014.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import <PAPreferences/PAPreferences.h>


extern NSString * const MPDidDetectFreshInstallationNotification;


@interface MPPreferences : PAPreferences

@property (assign) NSString *firstVersionInstalled;         /**< 已经安装的第一版 */
@property (assign) NSString *latestVersionInstalled;        /**< 已经安装的最新版 */
@property (assign) BOOL updateIncludesPreReleases;          /**< 包含预览版的更新提示。General 设置中：“Include pre-releases” */
@property (assign) BOOL supressesUntitledDocumentOnLaunch;  /**< 抑制启动时打开空白文档。General 设置中：“Ensure open document on launch” 取反*/
@property (assign) BOOL createFileForLinkTarget;            /**< TODO: 自动为链接目标创建文件。General 设置中：“Automatically create files for link targets” */

// Extension flags.
@property (assign) BOOL extensionIntraEmphasis;             /**< 支持单词中内嵌强调格式:。Markdown 设置中：“Intra-word emphasis” */
@property (assign) BOOL extensionTables;                    /**< TODO:。Markdown 设置中：“Table” */
@property (assign) BOOL extensionFencedCode;                /**< 支持围栏示代码块(```swift)。Markdown 设置中：“Fenced code block” */
@property (assign) BOOL extensionAutolink;                  /**< TODO:。Markdown 设置中：“Autolink” */
@property (assign) BOOL extensionStrikethough;              /**< 支持删除线。Markdown 设置中：“Strikethrough” */
@property (assign) BOOL extensionUnderline;                 /**< 支持下划线。Markdown 设置中：“Underline” */


@property (assign) BOOL extensionSuperscript;               /**< 支持配置脚本，需要取消 Jekyll...。Markdown 设置中：“Superscript”。@seealso https://github.com/MacDownApp/macdown/issues/396 */
@property (assign) BOOL extensionHighlight;                 /**< 支持语法高亮。Markdown 设置中：“Highlight” */
@property (assign) BOOL extensionFootnotes;                 /**< 支持角标标注格式。Markdown 设置中：“Footnote” */
@property (assign) BOOL extensionQuote;                     /**< 支持引用。Markdown 设置中：“Quote” */
@property (assign) BOOL extensionSmartyPants;               /**< Converts " or ' to left or right quote。Markdown 设置中：“Smartpants” */

@property (assign) BOOL markdownManualRender;               /**< 输入文字时自动更新预览。General 设置中：“Update preview automatically as you type” */

@property (assign) NSDictionary *editorBaseFontInfo;        /**< 存放编辑器的基础字体信息，包括字体名、字体大小 */
@property (assign) BOOL editorAutoIncrementNumberedLists;   /**< 在有序列表中编号数自动加1。Editor 设置中："Auto-increment numbering in ordered lists" */
@property (assign) BOOL editorConvertTabs;                  /**< 编辑器中使用空格替代制表符。Editor 设置中："Insert spaces instead of tabs" */
@property (assign) BOOL editorInsertPrefixInBlock;          /**< TODO:。Editor 设置中："Automatically insert line prefix for the current blocks" */
@property (assign) BOOL editorCompleteMatchingCharacters;   /**< 自动完成匹配的括号、引号等字符。Editor 设置中："Auto-complete matching characters" */
@property (assign) BOOL editorSyncScrolling;                /**< 编辑器与预览同步滚动。General 设置中：“Sync preview scrollbar when editor scrolls” */
@property (assign) BOOL editorSmartHome;                    /**< ⌘← 光标跳到一行的首个非空白字符左边。Editor 设置中："⌘← jumps to first non-whitespace character in line" */
@property (assign) NSString *editorStyleName;               /**< 编辑器的主题名。Editor 设置中：Theme Select 下拉菜单中选择 */
@property (assign) CGFloat editorHorizontalInset;           /**< 编辑器水平偏移数，最大35。Editor 设置中：x 左边的文本框 */
@property (assign) CGFloat editorVerticalInset;             /**< 编辑器垂直偏移数，最大35。Editor 设置中：x 右边的文本框 */
@property (assign) CGFloat editorLineSpacing;               /**< 编辑器行间距。Editor 设置中：Line spacing 右边的文本框 */
@property (assign) BOOL editorWidthLimited;                 /**< 编辑器中文字的最大宽度限制。Editor 设置中：“Limit editor width to" */
@property (assign) CGFloat editorMaximumWidth;              /**< 编辑器中文字的最大宽度值。Editor 设置中：“Limit editor ...” 右边的文本框 */
@property (assign) BOOL editorOnRight;                      /**< 编辑器位于右边。General 设置中：“Put editor on the right” */
@property (assign) BOOL editorShowWordCount;                /**< 在编辑器中，wordCountWidget 是否显示。General 设置中：“Show word count” */
@property (assign) NSInteger editorWordCountType;           /**< wordCountWidget 中的统计菜单的类型 */
@property (assign) BOOL editorScrollsPastEnd;               /**< TODO:。Editor 设置中："Scroll past end" */
@property (assign) BOOL editorEnsuresNewlineAtEndOfFile;    /**< 确保保存文件末尾的换行符。Editor 设置中："Ensure newline at end of file on save" */
@property (assign) NSInteger editorUnorderedListMarkerType; /**< 编辑器中无序列表的标记类型。Editor 设置中：“List marker" 右边的文本框 */

@property (assign) BOOL previewZoomRelativeToBaseFontSize;  /**< 依据编辑器的字体尺寸来缩放预览。Rendering 设置中：“Scale preview based on editor font size” */

@property (assign) NSString *htmlTemplateName;              /**< html 模板的名字 */
@property (assign) NSString *htmlStyleName;
@property (assign) BOOL htmlDetectFrontMatter;              /**< 支持Jekyll front-matter(放在文件开头)。Rendering 设置中：“Detect Jekyll front-matter” */
@property (assign) BOOL htmlTaskList;                       /**< 支持任务列表。Rendering 设置中：“Task list syntax” */
@property (assign) BOOL htmlHardWrap;                       /**< 预览中回车直接换行（原为两空格加换行或两个换行）。Rendering 设置中：“Render newline literally” */
@property (assign) BOOL htmlMathJax;                        /**< 代码块支持MathJax。Rendering 设置中：“TeX-like math syntax” */
@property (assign) BOOL htmlMathJaxInlineDollar;            /**< 代码块使用$符号作为内联分隔符。Rendering 设置中：“Use dollar sign ($) as inline delimiter” */
@property (assign) BOOL htmlSyntaxHighlighting;             /**< 有代码块需要语法高亮。Rendering 设置中：“Syntax highlighted code block” */
@property (assign) NSString *htmlHighlightingThemeName;
@property (assign) BOOL htmlLineNumbers;                    /**< 代码块需要显示行数。Rendering 设置中：“Show line numbers” */
@property (assign) BOOL htmlGraphviz;                       /**< 代码块支持Graphviz(Graph Visualization)。Rendering 设置中：“Graphviz”。 @seealso https://github.com/MacDownApp/macdown/pull/625 */
@property (assign) BOOL htmlMermaid;                        /**< 代码块支持Mermaid(Graph Visualization)。Rendering 设置中：“Mermaid”。 @seealso https://github.com/MacDownApp/macdown/pull/625 */
@property (assign) NSInteger htmlCodeBlockAccessory;        /**< 预览中的代码块附件，在右上角显示，由 MPCodeBlockAccessoryType 定义。Rendering 设置中：Accessory 选择 */
@property (assign) NSURL *htmlDefaultDirectoryUrl;
@property (assign) BOOL htmlRendersTOC;                     /**< 监测 TOC 元素。Rendering 设置中：“Detect table of contents token” */

// Calculated values.
@property (readonly) NSString *editorBaseFontName;
@property (readonly) CGFloat editorBaseFontSize;
@property (nonatomic, assign) NSFont *editorBaseFont;
@property (readonly) NSString *editorUnorderedListMarker;

- (instancetype)init;

// Convinience methods.
@property (nonatomic, assign) NSArray *filesToOpen;
@property (nonatomic, assign) NSString *pipedContentFileToOpen; /**< TODO: */

@end
