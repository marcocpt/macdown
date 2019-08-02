//
//  MPMainController.m
//  MacDown
//
//  Created by Tzu-ping Chung  on 7/06/2014.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import "MPMainController.h"
#import <MASPreferences/MASPreferencesWindowController.h>
#import <Sparkle/SUUpdater.h>
#import "MPGlobals.h"
#import "MPUtilities.h"
#import "NSDocumentController+Document.h"
#import "NSUserDefaults+Suite.h"
#import "MPPreferences.h"
#import "MPGeneralPreferencesViewController.h"
#import "MPMarkdownPreferencesViewController.h"
#import "MPEditorPreferencesViewController.h"
#import "MPHtmlPreferencesViewController.h"
#import "MPTerminalPreferencesViewController.h"
#import "MPDocument.h"


static NSString * const kMPTreatLastSeenStampKey = @"treatLastSeenStamp";

/** ✅ 将 Bundle 中的指定文件复制到 tmp 目录中，然后使用 NSDocumentController 进行打开，并设置边框大小为主屏幕的可见边框 */
NS_INLINE void MPOpenBundledFile(NSString *resource, NSString *extension)
{
    NSURL *source = [[NSBundle mainBundle] URLForResource:resource
                                            withExtension:extension];
    NSString *filename = source.absoluteString.lastPathComponent;
    NSURL *target = [NSURL fileURLWithPathComponents:@[NSTemporaryDirectory(),
                                                       filename]];
    BOOL ok = NO;
    NSFileManager *manager = [NSFileManager defaultManager];
    // 先试着移除文件，避免已经存在，然后再复制过去
    [manager removeItemAtURL:target error:NULL];
    ok = [manager copyItemAtURL:source toURL:target error:NULL];

    if (!ok)
        return;
    NSDocumentController *c = [NSDocumentController sharedDocumentController];
    [c openDocumentWithContentsOfURL:target display:YES completionHandler:
     ^(NSDocument *document, BOOL wasOpen, NSError *error) {
         if (!document || wasOpen || error)
             return;
         NSRect frame = [NSScreen mainScreen].visibleFrame;
         for (NSWindowController *wc in document.windowControllers)
             [wc.window setFrame:frame display:YES];
     }];
}

/** 恶搞... */
NS_INLINE void treat()
{
    NSDictionary *info = MPGetDataMap(@"treats");
    NSString *name = info[@"name"];
    if (![NSUserName().lowercaseString hasPrefix:name]
            && ![NSFullUserName().lowercaseString hasPrefix:name])
        return;

    NSDictionary *data = info[@"data"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit =
        NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *comps = [calendar components:unit fromDate:[NSDate date]];

    NSString *key =
        [NSString stringWithFormat:@"%02ld%02ld", comps.month, comps.day];
    if (!data[key])     // No matching treat.
        return;

    NSString *stamp = [NSString stringWithFormat:@"%ld%02ld%02ld",
                       comps.year, comps.month, comps.day];

    // User has seen this treat today.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:kMPTreatLastSeenStampKey] isEqual:stamp])
        return;

    [defaults setObject:stamp forKey:kMPTreatLastSeenStampKey];
    NSArray *components = @[NSTemporaryDirectory(), key];
    NSURL *url = [NSURL fileURLWithPathComponents:components];
    [data[key] writeToURL:url atomically:NO];

    // Make sure this is opened last and immediately visible.
    NSDocumentController *c = [NSDocumentController sharedDocumentController];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [c openDocumentWithContentsOfURL:url display:YES
                       completionHandler:MPDocumentOpenCompletionEmpty];
    }];
}


@interface MPMainController ()
@property (readonly) NSWindowController *preferencesWindowController;
@end


@implementation MPMainController

@synthesize preferencesWindowController = _preferencesWindowController;
/** ✅ 执行 `WebCache.disabled = YES`(private API), Registers the Apple event */
- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    // Using private API [WebCache setDisabled:YES] to disable WebView's cache
    // FIXME: https://stackoverflow.com/questions/16525065/disable-uiwebview-diskimagecache
    id webCacheClass = (id)NSClassFromString(@"WebCache");
    if (webCacheClass) {
// Ignoring "undeclared selector" warning
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        BOOL setDisabledValue = YES;
        NSMethodSignature *signature = [webCacheClass methodSignatureForSelector:@selector(setDisabled:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector = @selector(setDisabled:);
        invocation.target = [webCacheClass class];
        [invocation setArgument:&setDisabledValue atIndex:2];
        [invocation invoke];
#pragma clang diagnostic pop
    }
    // TODO: With enabled sandboxing, the handler method doesn't get called when the app is launched by clicking a URL that uses the custom scheme. By installing the handler a bit earlier, in applicationWillFinishLaunching:, the method gets called as expected
    // 参考：https://stackoverflow.com/questions/1991072/how-to-handle-with-a-default-url-scheme/1991164#1991164
    [[NSAppleEventManager sharedAppleEventManager]
        setEventHandler:self
            andSelector:@selector(openUrlSchemeAppleEvent:withReplyEvent:)
          forEventClass:kInternetEventClass andEventID:kAEFetchURL];
}

#pragma mark - Selector
/** ✅ Open a file from a browser with url of the form :
 "x-macdown://open?url=file:///path/to/a/file&line=123&column=45" */
- (void)openUrlSchemeAppleEvent:(NSAppleEventDescriptor *)event
                 withReplyEvent:(NSAppleEventDescriptor *)reply
{
    NSString *urlString = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    if (!urlString) {
        return;
    }
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    if (!url) {
        return;
    }
    // resolvingAgainstBaseURL 参数参考：https://stackoverflow.com/questions/38720933/whats-the-difference-between-passing-false-and-true-to-resolvingagainstbaseurl
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                                resolvingAgainstBaseURL:NO];
    if (!urlComponents) {
        return;
    }
    NSString *host = urlComponents.host;
    if (!host || ![host isEqualToString:@"open"]) {
        return;
    }
    NSArray *queryItems = urlComponents.queryItems;
    if (!queryItems) {
        return;
    }
    NSString *fileParam = [self valueForKey:@"url" fromQueryItems:queryItems];
    if (!fileParam) {
        return;
    }
    // FIXME: Could not figure out how to place the insertion point at a given
    // line and column.
    /* Unused */ NSString *lineParam = [self valueForKey:@"line"
                                          fromQueryItems:queryItems];
    /* Unused */ NSString *columnParam = [self valueForKey:@"column"
                                            fromQueryItems:queryItems];
    NSLog(@"%@:%@:%@", fileParam, lineParam, columnParam);

    NSURL *target = [NSURL URLWithString:fileParam];
    if (!target) {
        return;
    }
    NSDocumentController *c = [NSDocumentController sharedDocumentController];
    [c openDocumentWithContentsOfURL:target display:YES completionHandler:
     ^(NSDocument *document, BOOL wasOpen, NSError *error) {
         if (!document || wasOpen || error)
             return;
         NSRect frame = [NSScreen mainScreen].visibleFrame;
         for (NSWindowController *wc in document.windowControllers)
             [wc.window setFrame:frame display:YES];
     }];

}

#pragma mark - Private
/// ✅ 在 queryItems （NSArray<NSURLQueryItem *>） 中查找满足 key 的 queryItem.value
- (NSString *)valueForKey:(NSString *)key fromQueryItems:(NSArray *)queryItems
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems filteredArrayUsingPredicate:predicate] firstObject];
    return queryItem.value;
}

/// ✅ 获取 MPPreferences 的单例，首次执行会初始化
- (MPPreferences *)preferences
{
    return [MPPreferences sharedInstance];
}

/// ✅ 初始化配置窗口控制器，添加各个面板的控制器 */
- (NSWindowController *)preferencesWindowController
{
    if (!_preferencesWindowController)
    {
        NSArray *vcs = @[
            [[MPGeneralPreferencesViewController alloc] init],
            [[MPMarkdownPreferencesViewController alloc] init],
            [[MPEditorPreferencesViewController alloc] init],
            [[MPHtmlPreferencesViewController alloc] init],
            [[MPTerminalPreferencesViewController alloc] init],
        ];
        NSString *title = NSLocalizedString(@"Preferences",
                                            @"Preferences window title.");

        typedef MASPreferencesWindowController WC;
        _preferencesWindowController =
            [[WC alloc] initWithViewControllers:vcs title:title];
    }
    return _preferencesWindowController;
}

#pragma mark - Action
/// ✅ 显示配置窗口 */
- (IBAction)showPreferencesWindow:(id)sender
{
    [self.preferencesWindowController showWindow:nil];
}

/// ✅ 打开帮助文件
- (IBAction)showHelp:(id)sender
{
    MPOpenBundledFile(@"help", @"md");
}

/// ✅ 打开捐助文件
- (IBAction)showContributing:(id)sender
{
    MPOpenBundledFile(@"contribute", @"md");
}


#pragma mark - Override
/** ✅ 增加第一次安装的通知，并复制相关配置文件到 App root 目录 */
- (instancetype)init
{
    self = [super init];
    if (!self)
        return self;

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(showFirstLaunchTips)
                   name:MPDidDetectFreshInstallationNotification
                 object:self.preferences];
    [self copyFiles];
    return self;
}


#pragma mark - NSApplicationDelegate
/** NSApplicationDelegate: Invoked immediately before opening an untitled file. */
- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    if (self.preferences.filesToOpen.count || self.preferences.pipedContentFileToOpen)
        return NO;
    return !self.preferences.supressesUntitledDocumentOnLaunch;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self openPendingPipedContent];
    [self openPendingFiles];
    treat();
}


#pragma mark - SUUpdaterDelegate

- (NSString *)feedURLStringForUpdater:(SUUpdater *)updater
{
    if (self.preferences.updateIncludesPreReleases)
        return [NSBundle mainBundle].infoDictionary[@"SUBetaFeedURL"];
    return [NSBundle mainBundle].infoDictionary[@"SUFeedURL"];
}


#pragma mark - Private
/** 复制类型和主题文件到 App root 目录，不存在才复制*/
- (void)copyFiles
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *root = MPDataDirectory(nil);
    if (![manager fileExistsAtPath:root])
    {
        [manager createDirectoryAtPath:root
           withIntermediateDirectories:YES attributes:nil error:NULL];
    }

    NSBundle *bundle = [NSBundle mainBundle];
    for (NSString *key in @[kMPStylesDirectoryName, kMPThemesDirectoryName])
    {
        NSURL *dirSource = [bundle URLForResource:key withExtension:@""];
        NSURL *dirTarget = [NSURL fileURLWithPath:MPDataDirectory(key)];

        // If the directory doesn't exist, just copy the whole thing.
        if (![manager fileExistsAtPath:dirTarget.path])
        {
            [manager copyItemAtURL:dirSource toURL:dirTarget error:NULL];
            continue;
        }

        // Check for existence of each file and copy if it's not there.
        NSArray *contents = [manager contentsOfDirectoryAtURL:dirSource
                                   includingPropertiesForKeys:nil options:0
                                                        error:NULL];
        for (NSURL *fileSource in contents)
        {
            NSString *name = fileSource.lastPathComponent;
            NSURL *fileTarget = [dirTarget URLByAppendingPathComponent:name];
            if (![manager fileExistsAtPath:fileTarget.path])
                [manager copyItemAtURL:fileSource toURL:fileTarget error:NULL];
        }
    }
}

- (void)openPendingFiles
{
    NSDocumentController *c = [NSDocumentController sharedDocumentController];

    for (NSString *path in self.preferences.filesToOpen)
    {
        NSURL *url = [NSURL fileURLWithPath:path];
        if ([url checkResourceIsReachableAndReturnError:NULL])
        {
            [c openDocumentWithContentsOfURL:url display:YES
                           completionHandler:MPDocumentOpenCompletionEmpty];
        }
        else
        {
            [c createNewEmptyDocumentForURL:url display:YES error:NULL];
        }
    }

    self.preferences.filesToOpen = nil;
    [self.preferences synchronize];
}

- (void)openPendingPipedContent {
    NSDocumentController *c = [NSDocumentController sharedDocumentController];

    if (self.preferences.pipedContentFileToOpen) {
        NSURL *pipedContentFileToOpenURL = [NSURL fileURLWithPath:self.preferences.pipedContentFileToOpen];
        NSError *readPipedContentError;
        NSString *pipedContentString = [NSString stringWithContentsOfURL:pipedContentFileToOpenURL encoding:NSUTF8StringEncoding error:&readPipedContentError];

        NSError *openDocumentError;
        MPDocument *document = (MPDocument *)[c openUntitledDocumentAndDisplay:YES error:&openDocumentError];

        if (document && openDocumentError == nil && readPipedContentError == nil) {
            document.markdown = pipedContentString;
        }

        self.preferences.pipedContentFileToOpen = nil;
        [self.preferences synchronize];
    }
}


#pragma mark - Notification handler
/// MPDidDetectFreshInstallationNotification 通知处理的方法。在第一次安装时显示帮助文件
- (void)showFirstLaunchTips
{
    [self showHelp:nil];
    [self showContributing:nil];
}


@end
