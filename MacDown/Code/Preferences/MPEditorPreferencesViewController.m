//
//  MPEditorPreferencesViewController.m
//  MacDown
//
//  Created by Tzu-ping Chung  on 7/06/2014.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import "MPEditorPreferencesViewController.h"
#import "MPUtilities.h"
#import "MPPreferences.h"


NSString * const MPDidRequestEditorSetupNotificationKeyName =
    @"MPDidRequestEditorSetupNotificationKeyNameKey";


@interface MPEditorPreferencesViewController () <NSTextFieldDelegate>
@property (weak) IBOutlet NSTextField *fontPreviewField;        /**< Editor 设置中显示 Base font */
@property (weak) IBOutlet NSPopUpButton *themeSelect;
@property (weak) IBOutlet NSSegmentedControl *themeFunctions;
@end


@implementation MPEditorPreferencesViewController


#pragma mark - MASPreferencesViewController
/** MASPreferencesViewController：Unique identifier of the Panel represented by the view controller. */
- (NSString *)viewIdentifier
{
    return @"EditorPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"PreferencesEditor"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Editor", @"Preference pane title.");
}


#pragma mark - Override

- (void)viewWillAppear
{
    [self refreshPreviewForFont:[self.preferences.editorBaseFont copy]];
    [self loadThemes];
}


#pragma mark - Private
/** 更新 Editor 设置中显示 Base font 的文本框 */
- (void)refreshPreviewForFont:(NSFont *)font
{
    NSString *text = [NSString stringWithFormat:@"%@ - %.1lf",
                      font.displayName, font.pointSize];
    self.fontPreviewField.stringValue = text;
    self.fontPreviewField.font = font;
}
/** 加载可选的主题 */
- (void)loadThemes
{
    [self.themeSelect setEnabled:NO];
    [self.themeSelect removeAllItems];

    NSArray *itemTitles = MPListEntriesForDirectory(
        kMPThemesDirectoryName,
        MPFileNameHasExtensionProcessor(kMPThemeFileExtension)
    );

    [self.themeSelect addItemWithTitle:@""];
    [self.themeSelect addItemsWithTitles:itemTitles];

    NSString *title = [self.preferences.editorStyleName copy];
    if (title.length)
        [self.themeSelect selectItemWithTitle:title];

    [self.themeSelect setEnabled:YES];
}


#pragma mark - NSFontManager Delegate
/** NSFontManager Delegate: 设置面板中改变了字体 */
- (void)changeFont:(NSFontManager *)sender
{
    NSFont *font = [sender convertFont:sender.selectedFont];
    [self refreshPreviewForFont:font];
    self.preferences.editorBaseFont = font;
}


#pragma mark - NSTextFieldDelegate

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    if (!fieldEditor.string.length)
        fieldEditor.string = @"0";
    return YES;
}


#pragma mark - IBAction
/** 打开字体面板并选择字体作为编辑器的字体。Editor 设置中：“Change...” */
- (IBAction)showFontPanel:(id)sender
{
    NSFontManager *manager = [NSFontManager sharedFontManager];
    manager.target = self;
    manager.action = @selector(changeFont:);
    [manager setSelectedFont:[self.preferences.editorBaseFont copy]
                  isMultiple:NO];

    NSFontPanel *panel = [manager fontPanel:YES];
    [panel orderFront:sender];
}
/** 选择编辑器的主题。Editor 设置中：Theme Select 下拉菜单 */
- (IBAction)changeTheme:(NSPopUpButton *)sender
{
    NSString *title = sender.selectedItem.title;

    // Special case: the first (empty) item. No stylesheets will be used.
    if (!title.length)
        self.preferences.editorStyleName = nil;
    else
        self.preferences.editorStyleName = title;
}
/** Reveal: 使用 NSWorkspace 打开主题文件夹；Reload：手动加载主题。Editor 设置中：Reveal/Reload 选择 */
- (IBAction)invokeStylesheetFunction:(NSSegmentedControl *)sender
{
    switch (sender.selectedSegment)
    {
        case 0:     // Reveal
        {
            NSString *dirPath = MPDataDirectory(kMPThemesDirectoryName);
            NSURL *url = [NSURL fileURLWithPath:dirPath];
            NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
            [workspace activateFileViewerSelectingURLs:@[url]];
            break;
        }
        case 1:     // Reload
        {
            [self loadThemes];
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            NSString *name = MPDidRequestEditorSetupNotificationKeyName;
            NSString *key = NSStringFromSelector(@selector(editorStyleName));
            [center postNotificationName:MPDidRequestEditorSetupNotification
                                  object:self userInfo:@{name: key}];
            break;
        }
        default:
            break;
    }
}

@end
