# YouTube Music Free Provider

本加载项为现有 Music Assistant 安装并恢复第三方 YouTube Music Free 音乐源。不会删除或修改 LXServer（Subsonic）配置。

## 安装

1. 在 Home Assistant 的加载项商店中添加仓库：https://github.com/Yunlliang/ytmusic-free-ha-addon
2. 刷新商店，安装 YouTube Music Free Provider。
3. 在加载项信息页关闭 **保护模式（Protection mode）**，然后启动。
4. 在日志中确认 `Provider installed` 和 `Music Assistant restarted`。
5. 在 Music Assistant 的音乐源设置中添加 YouTube Music (Free)。

## 注意事项

- 首次安装会重启 Music Assistant，正在播放的音乐会中断。
- 需要 Docker API 和关闭保护模式，拥有较高宿主机权限，请自行评估风险。
- 初次启动从上游 main 分支下载插件；插件非官方，可能因 YouTube 或 Music Assistant 更新而失效。
- 目前自动更新功能未启用，重新创建容器时会恢复已缓存的插件文件。
- 此版本尚未在你的 HAOS 实例上实测。
