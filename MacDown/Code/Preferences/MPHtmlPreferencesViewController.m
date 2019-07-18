//
//  MPHtmlPreferencesViewController.m
//  MacDown
//
//  Created by Tzu-ping Chung  on 8/06/2014.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import "MPHtmlPreferencesViewController.h"
#import "MPUtilities.h"
#import "MPPreferences.h"


NS_INLINE NSString *MPPrismDefaultThemeName()
{
    return NSLocalizedString(@"(Default)", @"Prism theme title");
}


@interface MPHtmlPreferencesViewController ()
@property (weak) IBOutlet NSPopUpButton *stylesheetSelect;          /**< Rendering 设置中的 CSS 选择 */
@property (weak) IBOutlet NSSegmentedControl *stylesheetFunctions;  /**< Rendering 设置中的 Reveal/Reload 选择 */
@property (weak) IBOutlet NSPopUpButton *highlightingThemeSelect;   /**< Rendering 设置中的 Theme 选择 */
@end


@implementation MPHtmlPreferencesViewController

#pragma mark - MASPreferencesViewController
/** MASPreferencesViewController：Unique identifier of the Panel represented by the view controller. */
- (NSString *)viewIdentifier
{
    return @"HtmlPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"PreferencesRendering"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Rendering", @"Preference pane title.");
}


#pragma mark - Override

- (void)viewWillAppear
{
    [self loadStylesheets];
    [self loadHighlightingThemes];
}


#pragma mark - IBAction
/** Rendering 设置中选择 CSS 来设置 htmlStyleName */
- (IBAction)changeStylesheet:(NSPopUpButton *)sender
{
    NSString *title = sender.selectedItem.title;

    // Special case: the first (empty) item. No stylesheets will be used.
    if (!title.length)
        self.preferences.htmlStyleName = nil;
    else
        self.preferences.htmlStyleName = title;
}
/** Rendering 设置中选择主题来设置 htmlHighlightingThemeName 属性 */
- (IBAction)changeHighlightingTheme:(NSPopUpButton *)sender
{
    NSString *title = sender.selectedItem.title;
    if ([title isEqualToString:MPPrismDefaultThemeName()])
        self.preferences.htmlHighlightingThemeName = @"";
    else
        self.preferences.htmlHighlightingThemeName = title;
}
/** Rendering 设置中的 Reveal/Reload 选择。 Reveal：点击则打开存放Style的文件夹；Reload：发送 通知 MPDidRequestPreviewRenderNotification 来按指定的 CSS 渲染 */
- (IBAction)invokeStylesheetFunction:(NSSegmentedControl *)sender
{
    switch (sender.selectedSegment)
    {
        case 0:     // Reveal
        {
            NSString *dirPath = MPDataDirectory(kMPStylesDirectoryName);
            NSURL *url = [NSURL fileURLWithPath:dirPath];
            NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
            [workspace activateFileViewerSelectingURLs:@[url]];
            break;
        }
        case 1:     // Reload
        {
            [self loadStylesheets];
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:MPDidRequestPreviewRenderNotification
                                  object:self];
            break;
        }
        default:
            break;
    }
}


#pragma mark - Private

- (void)loadStylesheets
{
    self.stylesheetSelect.enabled = NO;
    [self.stylesheetSelect removeAllItems];

    NSArray *itemTitles = MPListEntriesForDirectory(
        kMPStylesDirectoryName,
        MPFileNameHasExtensionProcessor(kMPStyleFileExtension)
    );

    [self.stylesheetSelect addItemWithTitle:@""];
    [self.stylesheetSelect addItemsWithTitles:itemTitles];

    NSString *title = self.preferences.htmlStyleName;
    if (title.length)
        [self.stylesheetSelect selectItemWithTitle:title];

    self.stylesheetSelect.enabled = YES;
}

- (void)loadHighlightingThemes
{
    self.highlightingThemeSelect.enabled = NO;
    [self.highlightingThemeSelect removeAllItems];

    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *urls = [bundle URLsForResourcesWithExtension:@"css"
                                             subdirectory:@"Prism/themes"];
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:urls.count];
    for (NSURL *url in urls)
    {
        NSString *name = url.lastPathComponent;
        if (name.length <= 10)
            continue;
        name = [name substringWithRange:NSMakeRange(6, name.length - 10)];
        [titles addObject:[name capitalizedString]];
    }

    [self.highlightingThemeSelect addItemWithTitle:MPPrismDefaultThemeName()];
    [self.highlightingThemeSelect addItemsWithTitles:titles];

    NSString *currentName = self.preferences.htmlHighlightingThemeName;
    if (currentName.length)
        [self.highlightingThemeSelect selectItemWithTitle:currentName];

    if (self.preferences.htmlSyntaxHighlighting)
        self.highlightingThemeSelect.enabled = YES;
}

@end
