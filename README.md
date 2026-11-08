# YouTube Music Free — Home Assistant Add-on

在 Home Assistant OS 上，为现有 Music Assistant 自动安装及恢复第三方 YouTube Music Free Provider。

## 添加到 HA

1. 打开 **设置 → 加载项 / 应用商店 → 右上角 ⋮ → 仓库**。
2. 添加 `https://github.com/Yunlliang/ytmusic-free-ha-addon`。
3. 安装 **YouTube Music Free Provider**。
4. 在加载项信息页**关闭保护模式**，启动并查看日志。
5. 在 Music Assistant 中添加 **YouTube Music (Free)** 音乐源。

现有 **LXServer（Subsonic）** 不会被卸载或修改。首次启动会重启 Music Assistant，短暂中断播放。

## 工作原理

加载项每 15 秒检查 Music Assistant 容器。首次启动从 [sproft/ytmusic-free-provider](https://github.com/sproft/ytmusic-free-provider) 下载插件；容器被重建后重新复制缓存插件并重启 Music Assistant。

**安全提示：** 需要 Docker API 和关闭 HA 保护模式，权限较高；请仅在信任本仓库及上游源码时使用。第三方音乐源可能失效，使用时请遵守相关服务条款。

更多信息：[中文安装说明](ytmusic_free/DOCS.md)。

## 状态

初始版本 1.0.0；代码已提交，尚未在目标 HAOS 上完成安装和播放测试。自动更新默认关闭，当前版本不实现在线自动更新。
