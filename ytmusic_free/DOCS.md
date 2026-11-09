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

## 使用教程：音乐源配置与账户授权

### 1. 安装并验证加载项

1. 确认 **Music Assistant** 已运行。
2. 在 HA **设置 → 加载项商店 → ⋮ → 仓库** 添加本仓库地址，安装 **YouTube Music Free Provider**。
3. 在加载项的 **信息** 页面关闭 **保护模式（Protection mode）**，再启动。此操作授予 Docker 管理权限，请先确认信任代码。
4. 在日志中确认出现 `Starting YouTube Music Free watcher`、`Provider installed in ...music_assistant` 和 `Music Assistant restarted`。这些只表示插件文件安装成功，仍需在 Music Assistant 中配置音乐源。
5. 在 **Music Assistant → 设置 → 音乐源 → 添加音乐源** 中选择 **YouTube Music (Free)**。

### 2. 不登录也能使用

不填写账户 Cookie，仍可尝试搜索歌曲、专辑、艺术家、播放列表与播客，以及播放和浏览公开内容。个人资料库同步、个人推荐和资料库编辑需要授权。

### 3. 使用浏览器 Cookie 授权（可选）

1. 在电脑 Chrome 中打开 [YouTube Music](https://music.youtube.com)，登录需要同步的 Google / YouTube Music 账户。
2. 按 `F12` 打开开发者工具 → **Network（网络）** → **Fetch/XHR**，按 `F5` 刷新。
3. 点击成功的 `music.youtube.com` 请求，例如 `account_menu?prettyPrint=false`、`browse` 或 `get_search_suggestions?prettyPrint=false`。必须确认请求属于登录后的 YouTube Music 页面。
4. 在 **Headers → Request Headers** 中查找 `cookie`。复制其**完整值**（不包括 `Cookie:` 字样），不要复制响应标头 `Set-Cookie`。如果看不到，请换一个已完成的请求；`Application → Cookies` 显示的是单项 Cookie，不是完整请求标头。
5. 回到 **Music Assistant → 设置 → 音乐源 → YouTube Music (Free)**，设置：
   - **Authentication**：`Browser cookie`
   - **Cookie header**：粘贴上一步复制的完整 Cookie 值
   - **Brand account ID (optional)**：普通个人账户通常留空
   - **Account index (advanced)**：默认 `0`；多账户场景再调整
   - **Prefer highest audio quality**：按需开启
   - **Filter AI-generated music**：按个人偏好开启或关闭
   - **Blocked artists / Blocklist URL**：无屏蔽需求则留空
6. 保存配置。保存后**不一定弹出授权成功提示**，应检查音乐源状态、搜索播放以及个人资料库是否能读取。

**安全警告：Cookie 是敏感登录凭证，可能允许他人访问你的账户。不要发送给任何人，不要截图暴露其值，不要提交到 GitHub。仅在可信设备上操作；若泄露，应尽快撤销相关会话。**

### 4. 资料库同步与功能验证

- 在 Music Assistant 音乐源的 **同步/导入选项** 中勾选希望同步的歌曲、专辑、艺术家、播放列表和播客项目。
- 保存后等待首次同步；时间取决于资料库大小。
- 依次验证 **搜索歌曲并播放**、**资料库中的点赞歌曲/播放列表**、**探索（Discover）个性化推荐**、**已订阅播客**。
- 若资料库为空，先确认 YouTube Music 账户本身有收藏内容；空资料库不能单独证明认证失败。
- 如果认证失败，重新获取登录后的请求 Cookie，并查看 Music Assistant 日志中的认证错误；不要将 Cookie 值粘贴到日志或 Issue。

### 5. 自动更新与常见问题

- `auto_update: false`（默认）：使用缓存插件，Music Assistant 容器重建时自动恢复。
- `auto_update: true`：每 24 小时检查上游 `main` 分支提交；发现变化后下载、安装并重启 Music Assistant，可能中断播放。**当前并非按正式 Release 更新。**
- 加载项日志出现 `Docker unavailable`：检查是否已关闭保护模式。
- 日志出现 `Provider installed` 但音乐源列表没有出现：确认 Music Assistant 已重启，查看 Music Assistant 自身的错误日志。
- 需要撤销浏览器授权：清除 Music Assistant 中保存的 Cookie，并在 Google 账户中管理登录会话。

## 更新策略

配置项 `auto_update` 默认 **false**，仅在首次运行下载插件，之后在 Music Assistant 容器重建时自动恢复缓存。

设为 **true** 并重启本加载项后，会每 24 小时查询上游 main 分支最新提交；如与缓存版本不同，下载新版本并重启 Music Assistant。**检查到的每次提交不一定是稳定版本，重启会打断播放。**

上游下载或检查失败时保留缓存，不应影响 LXServer。加载项本身的更新仍由 Home Assistant 管理。

## 注意事项

- 需要 Docker API 和关闭保护模式，权限较高，请自行评估风险。
- 第三方音乐源可能因 YouTube 或 Music Assistant 更新而失效。
- 此版本未在你的 HAOS 实例上完成自动更新功能的实测。
