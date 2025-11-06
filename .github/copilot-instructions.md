## 项目快览 — 让 AI 立刻可用

这是一个以静态 HTML/CSS 为主的演示/地图可视化工程，仓库里没有统一的构建系统。关键资源分布：

- 静态页面：`1.html`, `try.html`, `greenroad.html`（含 Mapbox GL JS 示例与交互控件）
- 样式：`css/style.css`（注意当前文件仅包含极小样式片段）
- 空间数据与 QGIS/Quarto：`温榆河线图/` 下包含 `温榆河.geojson`、一组 shapefile，以及 `温榆河.qmd`（Quarto/文档描述/元数据）

主要约定与可操作线索（直接可用）：

- 地图实现：使用 Mapbox GL JS（多个文件中可见 `mapboxgl` 调用、`mapboxgl.accessToken` 和 `mapboxgl.baseApiUrl = null` 的 hack）。示例使用了外部高德瓦片作为 raster source，例如 `webrd01.is.autonavi.com`。
- 数据加载：GeoJSON 在页面中通过相对路径载入，典型路径为 `温榆河线图/温榆河.geojson`。如果修改或替换数据，确保相对路径与 HTML/JS 中的 `data` 字段一致。
- 风格与交互：线样式在 JS 中以 `map.addLayer({ type: 'line', paint: { 'line-color': '#4CAF50', ... }})` 配置。若需更改配色或粗细，优先修改这些 paint 属性；若要统一样式可把颜色常量移到样式表或单一配置文件。

开发/预览工作流（可直接运行）：

- 快速预览静态页面（推荐）：在项目根目录运行：

  ```powershell
  cd 'c:\Users\cheng\Desktop\tryyyyyy'
  python -m http.server 8000
  # 然后在浏览器打开 http://localhost:8000/1.html 或 try.html
  ```

- 若需要渲染 Quarto 文档（仓库含 `.qmd`）：

  - 仅当你有 Quarto 环境时可运行：
    ```powershell
    quarto render "温榆河线图/温榆河.qmd"
    ```
  - 如果 Quarto 不存在，该步骤会失败；这是可选渲染步骤而非必要构建流程。

项目特有注意点（AI 需要知道的“陷阱”）：

- Mapbox token 与 hack：示例文件中直接写入了 `mapboxgl.accessToken` 并设置 `mapboxgl.baseApiUrl = null`。不要在提交敏感私密 token；但目前仓库中的 token 看起来是公开示例 token。修改地图行为时注意这两处代码。
- 非 ASCII 路径：目录名 `温榆河线图/` 包含中文字符。编辑脚本或自动化时请确保使用 UTF-8 和适当的路径编码（Windows PowerShell 下路径直接可用，但在某些脚本/CI 环境需注意编码）。
- CSS 语法错误提醒：`css/style.css` 当前内容极短且有语法问题（例如 `h3 {color:blueviolet` 后缺少分号或右大括号），在应用样式前请修复该文件。

检查点与改动建议（可由 AI 自动完成的低风险改进）：

- 修复 `css/style.css` 的语法并提取常量（如主题颜色）到顶层变量。
- 将重复的 Mapbox 版本号和 token 抽离到单个 `config.js`（如果项目扩展到多个页面时）。
- 在 `温榆河线图/` 内保留原始数据（`.geojson`、`.shp`），并在页面中使用相对路径引用；若添加转换脚本，放在新目录 `tools/`。

范例片段（如何修改地图样式或数据）：

- 修改线颜色：在 `greenway` 相关 HTML/JS 中找到 `paint: { 'line-color': ... }` 并替换为所需颜色。
- 更换数据源：将 `data: '温榆河线图/温榆河.geojson'` 指向其他相对路径或 URL。

合并策略（当此文件已存在时）：

- 如果仓库已包含 `.github/copilot-instructions.md`，优先保留已有条目中针对本仓库的手工注释与历史说明；把本文件的“可操作命令”与“注意点”合并到已有节。不要覆盖原有的人类维护的使用细则。

结尾 / 反馈请求

我已把上述说明写入 `.github/copilot-instructions.md`（如果你希望我把某些样例改为更详细的代码片段或补充 CI/部署指令，请告诉我具体想要的命令或环境，我会更新）。
