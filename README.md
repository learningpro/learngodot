# WebTank Immersion

使用 Godot 4 构建的 2.5D 第一人称坦克体验，并配套自定义的网页壳层，支持 HTML5 全屏沉浸式游玩。

## 项目结构

- `project.godot`：Godot 项目的入口配置。
- `scenes/`：主要场景与节点资源，包括坦克、炮弹等。
- `scripts/`：GDScript 脚本，实现移动、射击和 UI 控制。
- `web/`：自定义网页容器，负责加载 HTML5 导出并提供全屏、指针锁定体验。

## 运行方式

1. 使用 Godot 打开项目并运行 `scenes/Main.tscn` 即可在编辑器内体验。
2. 若需 HTML5 发布：
   - 在 Godot 中进行 HTML5 导出，输出到 `web/build/` 目录。
   - 确保导出产生的文件命名为 `web_tank.wasm`、`web_tank.pck` 和 `godot.loader.js`（或在 `web/index.html` 中同步修改路径）。
   - 在 `web/` 目录下启动静态服务器，例如 `python -m http.server 8080`，然后访问 `http://localhost:8080`。

网页层会在点击“进入战场”后请求全屏和鼠标锁定，同时在游戏内使用方向键 / WASD 控制坦克移动，鼠标瞄准，左键开炮，Esc 释放鼠标并显示提示面板。

