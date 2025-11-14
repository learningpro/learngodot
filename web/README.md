# Web 部署说明

此目录包含自定义的 HTML5 启动页，可将 Godot 4 导出的 Web 版本打包为沉浸式全屏体验。

## 导出步骤

1. 在 Godot 编辑器中打开项目根目录（`project.godot`）。
2. 确保启用了 HTML5 导出模板，并创建名为 **WebTank**（或任意名称）的 HTML5 导出预设。
3. 将导出文件输出到 `web/build/` 目录下，建议文件命名如下：
   - `web_tank.wasm`
   - `web_tank.pck`
   - `godot.loader.js`

导出完成后，`web/index.html` 会自动加载上述文件并在 `canvas` 上渲染 Godot 游戏画面。

## 本地运行

```bash
cd web
python -m http.server 8080
```

然后在浏览器中访问 <http://localhost:8080>。点击“进入战场”按钮即可加载 Godot 游戏，同时支持全屏和鼠标锁定，营造 2.5D 第一人称坦克的沉浸体验。

