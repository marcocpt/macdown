#  Bug

- [ ] 主题修改后，重新运行无法更新，需要删除 ~/Library/Application Support/MacDown/Themes 中的文件重新生成
- [ ] 粘贴后，不会自动渲染，需要再次编辑
- [ ] 本地图片渲染时尺寸问题

# OpS

## [PAPreferences](https://github.com/dhennessy/PAPreferences)

An easy way to store user preferences using NSUserDefaults.

PAPreferences maps `dynamic` properties onto NSUserDefaults getters and setters so that you can access defaults as if they were regular properties on an object. That object is normally a singleton since you typically want a single set of preferences for the entire app.



## [MASPreferences](https://github.com/shpakovski/MASPreferences)

Modern implementation of the Preferences window for OS X apps, used in TextMate, GitBox and Mou:[http://blog.shpakovski.com/2011/04/pr…](http://blog.shpakovski.com/2011/04/preferences-windows-in-cocoa.html)