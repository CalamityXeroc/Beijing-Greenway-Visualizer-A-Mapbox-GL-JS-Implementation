# 北京绿道系统可视化平台

[English Documentation](./README.md)

一个现代化、交互式的Web GIS可视化平台，用于探索北京广泛的绿道网络系统。基于 Vue 3、OpenLayers 和 Vite 构建，为用户提供直观的界面来发现城市绿色廊道、生态空间和休闲路径。

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Vue](https://img.shields.io/badge/Vue-3.4.0-brightgreen.svg)
![OpenLayers](https://img.shields.io/badge/OpenLayers-8.2.0-blue.svg)

## ✨ 功能特性

### 交互式地图
- **全屏地图视图**：基于 OpenLayers 的高性能地图渲染
- **多图层可视化**：展示北京行政边界、绿道路线和生态要素
- **智能图层管理**：自由切换不同地图图层的可见性
- **响应式设计**：针对桌面和移动设备优化

### 高级 GIS 工具
- **绘制工具**：直接在地图上创建点、线和多边形
- **测量工具**：精确计算距离和面积
- **自定义图层上传**：导入您自己的 GeoJSON 数据进行分析
- **交互式弹窗**：点击要素查看详细信息

### 路线详情
- **温榆河绿道**：详细展示 108 公里的滨水路径
- **实时天气**：集成天气信息，方便规划出行
- **丰富图像**：绿道景点的视觉指南
- **全面信息**：覆盖区域、长度、设施和亮点

### 用户体验
- **可拖动弹窗**：在地图上自由移动信息窗口
- **流畅动画**：精致的过渡效果和悬停动画
- **直观导航**：易用的界面和清晰的视觉层次
- **信息卡片**：发现绿道统计数据、特色和使用指南

## 🚀 快速开始

### 环境要求
- **Node.js**：16.x 或更高版本
- **npm**：7.x 或更高版本（随 Node.js 一起安装）

### 安装步骤

1. **克隆仓库**
```bash
git clone https://github.com/yourusername/greenway-vue.git
cd greenway-vue
```

2. **安装依赖**
```bash
npm install
```

3. **启动开发服务器**
```bash
npm run dev
```

4. **打开浏览器**
访问 `http://localhost:5173`

### 生产环境构建

```bash
npm run build
```

构建文件将输出到 `dist/` 目录。

### 预览生产构建

```bash
npm run preview
```

## 📁 项目结构

```
greenway-vue/
├── public/              # 静态资源
│   └── 数据/            # GeoJSON 和空间数据
│       ├── 北京边界.geojson
│       ├── 北京面.geojson
│       └── 绿道/
│           └── 温榆河绿道/
├── src/
│   ├── components/      # Vue 组件
│   │   ├── MapViewer.vue       # 核心地图组件
│   │   ├── MapToolbar.vue      # GIS 工具集
│   │   └── WeatherCard.vue     # 天气组件
│   ├── views/           # 页面组件
│   │   ├── GreenwayOverview.vue  # 主概览页面
│   │   └── WenyuDetail.vue       # 温榆河详情页面
│   ├── core/            # 核心功能
│   │   └── MapManager.js         # 地图管理类
│   ├── router/          # Vue Router 配置
│   │   └── index.js
│   ├── App.vue          # 根组件
│   └── main.js          # 应用入口
├── index.html           # HTML 模板
├── vite.config.js       # Vite 配置
└── package.json         # 项目依赖
```

## 🛠️ 技术栈

### 核心框架
- **Vue 3.4.0**：渐进式 JavaScript 框架，使用 Composition API
- **Vue Router 4.2.5**：Vue.js 官方路由
- **Pinia 2.1.7**：状态管理库

### 地图与 GIS
- **OpenLayers 8.2.0**：高性能 Web 地图库
  - 矢量和栅格图层支持
  - 绘制和测量交互
  - GeoJSON 格式支持
  - 自定义样式和动画

### 开发工具
- **Vite 5.0.0**：下一代前端构建工具
- **@vitejs/plugin-vue 5.0.0**：Vite 的 Vue 3 插件

### HTTP 客户端
- **Axios 1.6.0**：基于 Promise 的 HTTP 客户端

## 🗺️ 数据来源

平台可视化的地理空间数据包括：
- 北京市行政边界
- 温榆河绿道路线（108公里）
- 生态区域和公园
- 文化遗产遗址
- 气象站位置

**数据格式**：GeoJSON (WGS84 / EPSG:4326)

## 🎨 功能详情

### 地图工具
- **点绘制**：标记感兴趣的位置
- **线绘制**：追踪路线和路径
- **多边形绘制**：定义区域和范围
- **距离测量**：计算路径长度（米/公里）
- **面积测量**：计算多边形面积（平方米/平方公里）
- **自定义图层**：上传并可视化您自己的 GeoJSON 文件
- **图层控制**：显示/隐藏基础图层和叠加图层

### 绿道信息
- **系统概览**：总长度、覆盖范围和连接点的统计数据
- **特色亮点**：山地景观、滨水空间、城市风貌、文化遗产、运动设施、生态保护
- **使用指南**：地图导航的交互式说明

### 温榆河绿道详情
- **长度**：108 公里
- **覆盖区域**：昌平、顺义、朝阳、通州四区
- **面积**：417 公顷
- **特色**：滨水生态景观、休闲步道系统

## 🌐 浏览器支持

- Chrome/Edge（推荐）：90+ 版本
- Firefox：88+ 版本
- Safari：14+ 版本

## 📝 开发指南

### 代码风格
- 使用 Vue 3 Composition API
- 遵循 Vue.js 风格指南
- 使用语义化 HTML5
- 模块化 CSS，使用 scoped 样式

### 组件指南
- 保持组件专注且可复用
- 使用 props 进行父子组件通信
- 使用 emit 事件进行子父组件通信
- 为复杂逻辑添加注释

## 🤝 贡献

欢迎贡献！请随时提交 Pull Request。

1. Fork 本仓库
2. 创建您的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开一个 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 详见 LICENSE 文件。

## 🙏 致谢

- 北京市规划和自然资源委员会提供绿道数据
- OpenLayers 社区提供优秀的地图库
- Vue.js 团队提供出色的框架
- 所有帮助改进本项目的贡献者

## 📧 联系方式

项目链接：[https://github.com/yourusername/greenway-vue](https://github.com/yourusername/greenway-vue)

---

**注意**：请将上述 URL 中的 `yourusername` 替换为您的实际 GitHub 用户名。

**用 ❤️ 构建，探索北京的绿色空间**
