# YouTube Music Free — Home Assistant Add-on

> **来源与署名 / Attribution**
>
> 音乐源由 **[sproft](https://github.com/sproft)** 开发，原始项目：[sproft/ytmusic-free-provider](https://github.com/sproft/ytmusic-free-provider)，采用 **MIT License**。
>
> 本仓库由 Yunlliang 独立维护，只提供 Home Assistant 加载项安装器与容器重建后的恢复、可选更新功能。**不是 GitHub Fork，不是原作者的官方发布，也不声称拥有音乐源代码。** 插件代码在运行时直接从原作者仓库下载。

## 功能支持（原作者音乐源）

下表整理自上游音乐源的功能说明。**未授权**指不连接 YouTube Music 账户；**已授权**指在 Music Assistant 音乐源配置中完成支持的账户授权。这些能力由 [sproft/ytmusic-free-provider](https://github.com/sproft/ytmusic-free-provider) 提供，并非本加载项独立开发；具体可用性以实际安装的上游版本及 YouTube 服务状态为准。

| 特征 | 未经授权 | 已授权 |
| --- | :---: | :---: |
| 搜索（歌曲、专辑、艺术家、播放列表、播客） | ✅ | ✅ |
| 添加方式：粘贴 YouTube / YTM 链接 | ✅ | ✅ |
| `@start-end` 剪辑带有时间戳的视频 | ✅ | ✅ |
| 音频流 | ✅ | ✅ |
| 艺人热门歌曲/专辑 | ✅ | ✅ |
| 相似歌曲（歌曲电台） | ✅ | ✅ |
| 专辑/播放列表曲目 | ✅ | ✅ |
| 资料库同步（歌曲、专辑、播放列表） | ❌ | ✅ |
| 资料库艺术家（订阅与点赞） | ❌ | ✅ |
| 个性化推荐 | ❌ | ✅ |
| 资料库编辑（添加/删除） | ❌ | ✅ |
| 多个账户并排显示 | ✅ | ✅ |
| 播客：搜索、浏览节目、播放剧集 | ✅ | ✅ |
| 播客库同步（已订阅节目） | ❌ | ✅ |

## 安装

1. 在 Home Assistant **设置 → 加载项商店 → ⋮ → 仓库** 添加 `https://github.com/Yunlliang/ytmusic-free-ha-addon`。
2. 安装 **YouTube Music Free Provider**。
3. 在加载项信息页关闭 **保护模式**，启动并查看日志。
4. 在 Music Assistant **设置 → 音乐源** 添加 **YouTube Music (Free)**。

## 跟随上游更新

- 默认 `auto_update: false`：首次下载并缓存上游版本；Music Assistant 容器重建后自动恢复缓存版本。
- 手动开启 `auto_update: true` 后：加载项运行时每 **24 小时** 检查原作者 `main` 分支的提交 SHA；只有发生变化才下载新代码、重新安装并重启 Music Assistant。
- 检查更新的单位是 **上游 Git 提交**，不保证每次提交都是稳定发行版；若更新失败，可关闭自动更新并从备份恢复。
- **自动更新可能打断播放，且上游变化可能导致兼容性问题。** 建议先保持关闭，确认运行稳定后再启用。
- 自动更新只针对上游音乐源代码；加载项本身仍需通过 Home Assistant 更新。

## 安全与独立性

需要 Docker API 与关闭保护模式，具有较高宿主机权限。请确认信任本仓库及上游代码后再启用。

LXServer（Subsonic）是另一独立音乐源，本加载项不会修改 LXServer 设置。

详细操作：[中文说明](ytmusic_free/DOCS.md)。
