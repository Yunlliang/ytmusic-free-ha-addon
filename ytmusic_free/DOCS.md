# YouTube Music Free Provider — 中文使用说明

## 项目来源

- **原作者**：[sproft](https://github.com/sproft)
- **上游项目**：[sproft/ytmusic-free-provider](https://github.com/sproft/ytmusic-free-provider)
- **上游许可证**：MIT
- 本项目是独立制作的 Home Assistant 加载项安装器，**不是 GitHub Fork，也不是官方发布**。插件文件直接下载自原作者项目。

## 安装

1. 在 Home Assistant 加载项商店添加仓库：https://github.com/Yunlliang/ytmusic-free-ha-addon
2. 安装 YouTube Music Free Provider。
3. 在加载项信息页关闭 **保护模式（Protection mode）**，启动。
4. 在日志中确认 `Provider installed` 和 `Music Assistant restarted`。
5. 在 Music Assistant 的音乐源设置中添加 YouTube Music (Free)。

## 更新策略

配置项 `auto_update` 默认 **false**，仅在首次运行下载插件，之后在 Music Assistant 容器重建时自动恢复缓存。

设为 **true** 并重启本加载项后，会每 24 小时查询上游 main 分支最新提交；如与缓存版本不同，下载新版本并重启 Music Assistant。**检查到的每次提交不一定是稳定版本，重启会打断播放。**

上游下载或检查失败时保留缓存，不应影响 LXServer。加载项本身的更新仍由 Home Assistant 管理。

## 注意事项

- 需要 Docker API 和关闭保护模式，权限较高，请自行评估风险。
- 第三方音乐源可能因 YouTube 或 Music Assistant 更新而失效。
- 此版本未在你的 HAOS 实例上完成自动更新功能的实测。
