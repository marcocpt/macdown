#  Bug

- [ ] 主题修改后，重新运行无法更新，需要删除 ~/Library/Application Support/MacDown/Themes 中的文件重新生成
- [ ] 粘贴后，不会自动渲染，需要再次编辑
- [ ] 本地图片渲染时尺寸问题

# OpS



## [handlebars-objc](https://github.com/Bertrand/handlebars-objc)

参考：《ABC——软件 K》 “模板引擎”

handlebars-objc is a feature-complete implementation of Handlebars.js for Objective-C

- [Handlebars.js](http://handlebarsjs.com/):  Minimal Templating on Steroids

## [Hoedown](https://github.com/hoedown/hoedown)

for Markdown-to-HTML rendering

## [JJPluralForm](https://github.com/junjie/JJPluralForm) 

Adaptation of Mozilla&#39;s PluralForm localization project to Objective-C

## [MASPreferences](https://github.com/shpakovski/MASPreferences)

Modern implementation of the Preferences window for OS X apps, used in TextMate, GitBox and Mou:[http://blog.shpakovski.com/2011/04/pr…](http://blog.shpakovski.com/2011/04/preferences-windows-in-cocoa.html)

## [PAPreferences](https://github.com/dhennessy/PAPreferences)

An easy way to store user preferences using NSUserDefaults.

PAPreferences maps `dynamic` properties onto NSUserDefaults getters and setters so that you can access defaults as if they were regular properties on an object. That object is normally a singleton since you typically want a single set of preferences for the entire app.

## [Prism](http://prismjs.com/)

for syntax highlighting (in code blocks)

## [Sparkle](https://github.com/sparkle-project/Sparkle)

A software update framework for macOS



# Jekyll front-matter

If you like, I can display **Jekyll front-matter** in a nice table. Just make sure you **put the front-matter at the very beginning** of the file, and **fence it with `---`.** For example:

```
---
title: "Macdown is my friend"
date: 2014-06-06 20:00:00
---
```

## 参考

- [ ] [Front Matter | Jekyll • Simple, blog-aware, static sites](https://jekyllrb.com/docs/front-matter/): 

## 代码

```objc
// NSString (Lookup)
/** 找到 Jekyll front-matter，计数出偏移的位置并用 YAMLSerialization 解析 */
- (id)frontMatter:(NSUInteger *)contentOffset;
```



# Mermaid

Graph Visualization



# Graphviz

Graph Visualization



# Hidden preference

You can see the HTML behind a preview by enabling the OS X built-in WebKit developer tools for MacDown in a terminal window:

```
defaults write com.uranusjr.macdown WebKitDeveloperExtras -bool true
```

Then select “Inspect Element” in the right-click context menu inside the preview pane.

This is the exact same inspector you find in Safari if you turn on the developer tools.