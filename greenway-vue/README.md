# Beijing Greenway System Visualization Platform# Beijing Greenway System Visualization Platform# Beijing Greenway System Visualization Platform# 北京绿道系统 Vue 版本



[中文文档](./README_zh-CN.md)



Interactive web GIS platform for exploring Beijing's greenway network. Built with Vue 3, OpenLayers, and Vite.[中文文档](./README_zh-CN.md)



![License](https://img.shields.io/badge/license-MIT-blue.svg)

![Vue](https://img.shields.io/badge/Vue-3.4.0-brightgreen.svg)

![OpenLayers](https://img.shields.io/badge/OpenLayers-8.2.0-blue.svg)A modern, interactive web-based GIS visualization platform for exploring Beijing's extensive greenway network. Built with Vue 3, OpenLayers, and Vite, this application provides an intuitive interface for discovering urban green corridors, ecological spaces, and recreational pathways across Beijing.[中文文档](./README_zh-CN.md)基于 **Vue 3 + OpenLayers + OLTB架构** 重构的北京绿道系统展示平台。



## ✨ Features



- **Interactive Mapping**: Full-screen map with multi-layer visualization![License](https://img.shields.io/badge/license-MIT-blue.svg)

- **GIS Tools**: Drawing, measurement, and custom GeoJSON layer upload

- **Route Details**: Wenyu River Greenway (108km) with weather integration![Vue](https://img.shields.io/badge/Vue-3.4.0-brightgreen.svg)

- **Draggable Popups**: Movable information windows

- **Responsive Design**: Optimized for desktop and mobile![OpenLayers](https://img.shields.io/badge/OpenLayers-8.2.0-blue.svg)A modern, interactive web-based GIS visualization platform for exploring Beijing's extensive greenway network. Built with Vue 3, OpenLayers, and Vite, this application provides an intuitive interface for discovering urban green corridors, ecological spaces, and recreational pathways across Beijing.## ✨ 特性



## 🚀 Quick Start



```bash## ✨ Features

# Clone repository

git clone https://github.com/yourusername/greenway-vue.git

cd greenway-vue

### Interactive Mapping![License](https://img.shields.io/badge/license-MIT-blue.svg)- ✅ **Vue 3 Composition API** - 现代化的 Vue 3 开发

# Install dependencies

npm install- **Full-Screen Map View**: High-performance map rendering powered by OpenLayers



# Start development server- **Multi-Layer Visualization**: Display Beijing administrative boundaries, greenway routes, and ecological features![Vue](https://img.shields.io/badge/Vue-3.4.0-brightgreen.svg)- ✅ **OpenLayers 8.2.0** - 强大的地图引擎

npm run dev

- **Smart Layer Management**: Toggle visibility of different map layers

# Build for production

npm run build- **Responsive Design**: Optimized for desktop and mobile devices![OpenLayers](https://img.shields.io/badge/OpenLayers-8.2.0-blue.svg)- ✅ **OLTB 架构模式** - 参考 OLTB 的模块化设计

```



## 📁 Project Structure

### Advanced GIS Tools- ✅ **响应式设计** - 完美适配桌面和移动端

```

greenway-vue/- **Drawing Tools**: Create points, lines, and polygons directly on the map

├── public/数据/        # GeoJSON spatial data

├── src/- **Measurement Tools**: Calculate distances and areas with precision## ✨ Features- ✅ **组件化开发** - 高度可复用的组件设计

│   ├── components/     # MapViewer, MapToolbar, WeatherCard

│   ├── views/          # GreenwayOverview, WenyuDetail- **Custom Layer Upload**: Import your own GeoJSON data for analysis

│   ├── core/           # MapManager

│   └── router/         # Vue Router config- **Interactive Popups**: Click features to view detailed information- ✅ **实时天气** - 集成高德天气 API

├── vite.config.js

└── package.json

```

### Route Details### Interactive Mapping- ✅ **平滑动画** - 优雅的页面过渡效果

## 🛠️ Tech Stack

- **Wenyu River Greenway**: Detailed showcase of the 108km waterfront pathway

- **Vue 3.4.0** - Composition API

- **OpenLayers 8.2.0** - Web mapping library- **Real-Time Weather**: Integrated weather information for trip planning- **Full-Screen Map View**: High-performance map rendering powered by OpenLayers

- **Vue Router 4.2.5** - Routing

- **Vite 5.0.0** - Build tool- **Rich Imagery**: Visual guide to greenway attractions

- **Axios 1.6.0** - HTTP client

- **Comprehensive Information**: Coverage area, length, facilities, and highlights- **Multi-Layer Visualization**: Display Beijing administrative boundaries, greenway routes, and ecological features## 📁 项目结构

## 🎨 Key Features



**Map Tools**: Point/Line/Polygon drawing, distance/area measurement, custom layer upload, layer control

### User Experience- **Smart Layer Management**: Toggle visibility of different map layers

**Greenway Info**: System overview, featured highlights, usage guide

- **Draggable Popups**: Move information windows freely on the map

**Wenyu River**: 108km waterfront pathway spanning 4 districts, 417 hectares

- **Smooth Animations**: Polished transitions and hover effects- **Responsive Design**: Optimized for desktop and mobile devices```

## 🌐 Browser Support

- **Intuitive Navigation**: Easy-to-use interface with clear visual hierarchy

Chrome/Edge 90+ | Firefox 88+ | Safari 14+

- **Information Cards**: Discover greenway statistics, features, and usage guidesgreenway-vue/

## 🤝 Contributing



Contributions welcome! Fork, create feature branch, commit, push, and open a PR.### Prerequisites- **Drawing Tools**: Create points, lines, and polygons directly on the map├── src/



## 📄 License- **Node.js**: 16.x or higher



MIT License- **npm**: 7.x or higher (comes with Node.js)- **Measurement Tools**: Calculate distances and areas with precision│   ├── assets/            # 样式资源



## 📧 Contact



Project Link: [https://github.com/yourusername/greenway-vue](https://github.com/yourusername/greenway-vue)### Installation- **Custom Layer Upload**: Import your own GeoJSON data for analysis│   │   └── main.css       # 全局样式



---



**Note**: Replace `yourusername` with your GitHub username.1. **Clone the repository**- **Interactive Popups**: Click features to view detailed information│   ├── components/        # Vue 组件


```bash

git clone https://github.com/yourusername/greenway-vue.git│   │   ├── MapViewer.vue  # 地图组件

cd greenway-vue

```### Route Details│   │   └── WeatherCard.vue # 天气卡片



2. **Install dependencies**- **Wenyu River Greenway**: Detailed view with 108km of riverside paths│   ├── core/              # 核心模块

```bash

npm install- **Real-Time Weather**: Integrated weather information for planning your visit│   │   ├── MapManager.js  # 地图管理器

```

- **Rich Imagery**: Visual guides to greenway attractions│   │   └── LayerManager.js # 图层管理器

3. **Start development server**

```bash- **Comprehensive Info**: Coverage area, length, facilities, and highlights│   ├── views/             # 页面组件

npm run dev

```│   │   ├── GreenwayOverview.vue  # 绿道总览



4. **Open in browser**### User Experience│   │   └── WenyuDetail.vue       # 温榆河详情

Navigate to `http://localhost:5173`

- **Draggable Popups**: Move information windows freely across the map│   ├── router/            # 路由配置

### Build for Production

- **Smooth Animations**: Polished transitions and hover effects│   │   └── index.js

```bash

npm run build- **Intuitive Navigation**: Easy-to-use interface with clear visual hierarchy│   ├── App.vue            # 根组件

```

- **Information Cards**: Discover greenway statistics, features, and usage guides│   └── main.js            # 入口文件

The build artifacts will be stored in the `dist/` directory.

├── index.html

### Preview Production Build

## 🚀 Quick Start├── package.json

```bash

npm run preview└── vite.config.js

```

### Prerequisites```

## 📁 Project Structure

- **Node.js**: Version 16.x or higher

```

greenway-vue/- **npm**: Version 7.x or higher (comes with Node.js)## 🚀 快速开始

├── public/              # Static assets

│   └── 数据/            # GeoJSON and spatial data

│       ├── 北京边界.geojson

│       ├── 北京面.geojson### Installation### 1. 安装依赖

│       └── 绿道/

│           └── 温榆河绿道/

├── src/

│   ├── components/      # Vue components1. **Clone the repository**确保已安装 Node.js (推荐 v18+)

│   │   ├── MapViewer.vue       # Core map component

│   │   ├── MapToolbar.vue      # GIS toolset```bash

│   │   └── WeatherCard.vue     # Weather widget

│   ├── views/           # Page componentsgit clone https://github.com/yourusername/greenway-vue.git```powershell

│   │   ├── GreenwayOverview.vue  # Main overview page

│   │   └── WenyuDetail.vue       # Wenyu River detail pagecd greenway-vuecd greenway-vue

│   ├── core/            # Core utilities

│   │   └── MapManager.js         # Map management class```npm install

│   ├── router/          # Vue Router configuration

│   │   └── index.js```

│   ├── App.vue          # Root component

│   └── main.js          # Application entry point2. **Install dependencies**

├── index.html           # HTML template

├── vite.config.js       # Vite configuration```bash### 2. 复制数据文件

└── package.json         # Project dependencies

```npm install



## 🛠️ Technology Stack```将数据文件夹复制到 `public` 目录：



### Core Framework

- **Vue 3.4.0**: Progressive JavaScript framework with Composition API

- **Vue Router 4.2.5**: Official router for Vue.js3. **Start development server**```powershell

- **Pinia 2.1.7**: State management library

```bash# 从父目录复制数据

### Mapping & GIS

- **OpenLayers 8.2.0**: High-performance web mapping librarynpm run devCopy-Item -Path "..\数据" -Destination ".\public\" -Recurse

  - Vector and raster layer support

  - Draw and measure interactions``````

  - GeoJSON format support

  - Custom styling and animations



### Development Tools4. **Open your browser**### 3. 启动开发服务器

- **Vite 5.0.0**: Next-generation frontend build tool

- **@vitejs/plugin-vue 5.0.0**: Vue 3 plugin for ViteNavigate to `http://localhost:5173`



### HTTP Client```powershell

- **Axios 1.6.0**: Promise-based HTTP client

### Build for Productionnpm run dev

## 🗺️ Data Sources

```

The platform visualizes geospatial data including:

- Beijing municipal administrative boundaries```bash

- Wenyu River Greenway route (108km)

- Ecological zones and parksnpm run build浏览器会自动打开 `http://localhost:5173`

- Cultural heritage sites

- Weather station locations```



**Data Format**: GeoJSON (WGS84 / EPSG:4326)### 4. 构建生产版本



## 🎨 Features in DetailThe built files will be in the `dist/` directory.



### Map Tools```powershell

- **Point Drawing**: Mark locations of interest

- **Line Drawing**: Trace routes and paths### Preview Production Buildnpm run build

- **Polygon Drawing**: Define areas and zones

- **Distance Measurement**: Calculate path lengths (meters/kilometers)```

- **Area Measurement**: Calculate polygon areas (square meters/square kilometers)

- **Custom Layers**: Upload and visualize your own GeoJSON files```bash

- **Layer Control**: Show/hide base layers and overlays

npm run preview生成的文件在 `dist` 目录。

### Greenway Information

- **System Overview**: Statistics on total length, coverage, and connection points```

- **Featured Highlights**: Mountain scenery, waterfront spaces, urban landscapes, cultural heritage, sports facilities, ecological conservation

- **Usage Guide**: Interactive instructions for map navigation## 📦 核心依赖



### Wenyu River Greenway Details## 📁 Project Structure

- **Length**: 108 kilometers

- **Coverage Area**: Spans four districts: Changping, Shunyi, Chaoyang, and Tongzhou```json

- **Area**: 417 hectares

- **Features**: Waterfront ecological landscape, recreational trail system```{



## 🌐 Browser Supportgreenway-vue/  "vue": "^3.4.0",



- Chrome/Edge (Recommended): 90+├── public/              # Static assets  "vue-router": "^4.2.5",

- Firefox: 88+

- Safari: 14+│   └── 数据/            # GeoJSON and spatial data  "ol": "^8.2.0"



## 📝 Development│       ├── 北京边界.geojson}



### Code Style│       ├── 北京面.geojson```

- Use Vue 3 Composition API

- Follow Vue.js Style Guide│       └── 绿道/

- Use semantic HTML5

- Modular CSS with scoped styles│           └── 温榆河绿道/## 🎨 设计亮点



### Component Guidelines├── src/

- Keep components focused and reusable

- Use props for parent-to-child communication│   ├── components/      # Vue components### 1. **核心架构 (参考 OLTB)**

- Use emit events for child-to-parent communication

- Document complex logic with comments│   │   ├── MapViewer.vue       # Core map component



## 🤝 Contributing│   │   ├── MapToolbar.vue      # GIS toolset```javascript



Contributions are welcome! Please feel free to submit a Pull Request.│   │   └── WeatherCard.vue     # Weather widget// MapManager - 地图核心管理



1. Fork the repository│   ├── views/           # Page componentsimport { getMapManager } from '@/core/MapManager'

2. Create your feature branch (`git checkout -b feature/AmazingFeature`)

3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)│   │   ├── GreenwayOverview.vue  # Main overview pageconst mapManager = getMapManager()

4. Push to the branch (`git push origin feature/AmazingFeature`)

5. Open a Pull Request│   │   └── WenyuDetail.vue       # Wenyu River detail pagemapManager.init('map-container', options)



## 📄 License│   ├── core/            # Core functionality



This project is licensed under the MIT License - see the LICENSE file for details.│   │   └── MapManager.js         # Map management class// LayerManager - 图层管理



## 🙏 Acknowledgments│   ├── router/          # Vue Router configurationimport { getLayerManager } from '@/core/LayerManager'



- Beijing Municipal Commission of Planning and Natural Resources for greenway data│   │   └── index.jsconst layerManager = getLayerManager()

- OpenLayers community for the excellent mapping library

- Vue.js team for the outstanding framework│   ├── App.vue          # Root componentconst layer = layerManager.createVectorLayerFromGeoJSON({ url: '...' })

- All contributors who have helped improve this project

│   └── main.js          # Application entry point```

## 📧 Contact

├── index.html           # HTML template

Project Link: [https://github.com/yourusername/greenway-vue](https://github.com/yourusername/greenway-vue)

├── vite.config.js       # Vite configuration### 2. **地图组件使用**

---

└── package.json         # Project dependencies

**Note**: Please replace `yourusername` in the URLs above with your actual GitHub username.

``````vue

**Built with ❤️ for exploring Beijing's green spaces**

<template>

## 🛠️ Technology Stack  <MapViewer

    :center="[116.5, 40]"

### Core Framework    :zoom="10"

- **Vue 3.4.0**: Progressive JavaScript framework with Composition API    :layers="layers"

- **Vue Router 4.2.5**: Official router for Vue.js    @map-ready="onMapReady"

- **Pinia 2.1.7**: State management library    @feature-click="onFeatureClick"

  />

### Mapping & GIS</template>

- **OpenLayers 8.2.0**: High-performance web mapping library

  - Vector and raster layer support<script setup>

  - Drawing and measurement interactionsimport MapViewer from '@/components/MapViewer.vue'

  - GeoJSON format support

  - Custom styling and animationsconst layers = [

  {

### Development Tools    id: 'greenway',

- **Vite 5.0.0**: Next-generation frontend build tool    type: 'geojson',

- **@vitejs/plugin-vue 5.0.0**: Vue 3 plugin for Vite    url: '/数据/绿道/温榆河绿道/温榆河.geojson',

    style: { lineColor: '#4CAF50', lineWidth: 4 }

### HTTP Client  }

- **Axios 1.6.0**: Promise-based HTTP client]

</script>

## 🗺️ Data Sources```



The platform visualizes geospatial data including:### 3. **天气组件使用**

- Beijing administrative boundaries

- Wenyu River Greenway route (108km)```vue

- Ecological zones and parks<template>

- Cultural heritage sites  <WeatherCard

- Weather station locations    :longitude="116.5"

    :latitude="40"

**Data Format**: GeoJSON (WGS84 / EPSG:4326)    @weather-loaded="onWeatherLoaded"

  />

## 🎨 Features in Detail</template>

```

### Map Tools

- **Point Drawing**: Mark locations of interest## 🔧 配置说明

- **Line Drawing**: Trace routes and paths

- **Polygon Drawing**: Define areas and regions### Vite 配置 (vite.config.js)

- **Distance Measurement**: Calculate path lengths (meters/kilometers)

- **Area Measurement**: Calculate polygon areas (square meters/square kilometers)- **路径别名**: `@` → `./src`

- **Custom Layers**: Upload and visualize your own GeoJSON files- **开发端口**: 5173

- **Layer Control**: Show/hide base layers and overlays- **自动打开浏览器**: 是



### Greenway Information### 路由配置

- **System Overview**: Statistics on total length, coverage, and connections

- **Feature Highlights**: Mountain views, waterfront spaces, urban landscapes, cultural heritage, sports facilities, ecological protection- `/` - 绿道总览页

- **Usage Guide**: Interactive instructions for map navigation- `/wenyu` - 温榆河详情页



### Wenyu River Greenway Details## 🎯 核心功能

- **Length**: 108 kilometers

- **Coverage**: Changping, Shunyi, Chaoyang, Tongzhou districts### 1. **绿道总览页** (`GreenwayOverview.vue`)

- **Area**: 417 hectares

- **Features**: Riverside ecological landscape, leisure trail system- ✅ 多图层展示（北京市域、市界、绿道）

- ✅ 图层控制开关

## 🌐 Browser Support- ✅ 点击要素显示信息

- ✅ 弹窗展示绿道详情

- Chrome/Edge (recommended): Version 90+- ✅ 跳转到详情页

- Firefox: Version 88+

- Safari: Version 14+### 2. **温榆河详情页** (`WenyuDetail.vue`)



## 📝 Development- ✅ 绿道线路展示

- ✅ 实时天气信息

### Code Style- ✅ 绿道亮点介绍

- Use Vue 3 Composition API- ✅ 图片展示

- Follow Vue.js style guide- ✅ 返回导航

- Use semantic HTML5

- Modular CSS with scoped styles### 3. **地图组件** (`MapViewer.vue`)



### Component Guidelines- ✅ 高德底图

- Keep components focused and reusable- ✅ GeoJSON 图层加载

- Use props for parent-child communication- ✅ 事件监听（点击、悬停）

- Emit events for child-parent communication- ✅ 动态样式

- Document complex logic with comments- ✅ 自适应范围



## 🤝 Contributing### 4. **天气组件** (`WeatherCard.vue`)



Contributions are welcome! Please feel free to submit a Pull Request.- ✅ 高德天气 API 集成

- ✅ 自动刷新（30分钟）

1. Fork the repository- ✅ 手动刷新按钮

2. Create your feature branch (`git checkout -b feature/AmazingFeature`)- ✅ 错误处理和重试

3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)

4. Push to the branch (`git push origin feature/AmazingFeature`)## 🌟 与原版 HTML 对比

5. Open a Pull Request

| 特性 | 原版 HTML | Vue 版本 |

## 📄 License|------|----------|----------|

| 框架 | 原生 JS | Vue 3 |

This project is licensed under the MIT License - see the LICENSE file for details.| 代码组织 | 单文件 | 模块化组件 |

| 状态管理 | 全局变量 | Reactive/Ref |

## 🙏 Acknowledgments| 路由 | 页面跳转 | Vue Router |

| 可维护性 | 低 | 高 |

- Beijing Municipal Commission of Planning and Natural Resources for greenway data| 可扩展性 | 差 | 好 |

- OpenLayers community for the excellent mapping library| 开发效率 | 低 | 高 |

- Vue.js team for the amazing framework

- All contributors who help improve this project## 📝 开发建议



## 📧 Contact### 添加新图层



Project Link: [https://github.com/yourusername/greenway-vue](https://github.com/yourusername/greenway-vue)```javascript

// 在 layers 配置中添加

---const layers = ref([

  // ... 现有图层

**Note**: Replace `yourusername` with your actual GitHub username in the URLs above.  {

    id: 'new-layer',

**Built with ❤️ for exploring Beijing's green spaces**    type: 'geojson',

    url: '/数据/新图层.geojson',
    visible: true,
    style: {
      lineColor: '#FF5722',
      lineWidth: 3
    }
  }
])
```

### 自定义样式

```javascript
// 在 LayerManager 中使用样式函数
const styleFunction = layerManager.createStyleFunction({
  lineColor: '#4CAF50',
  lineWidth: 4
})
```

### 添加地图交互

```vue
<MapViewer
  @map-click="onMapClick"
  @feature-hover="onFeatureHover"
  @center-changed="onCenterChanged"
/>
```

## 🐛 常见问题

### Q1: 数据文件找不到？

确保已将 `数据` 文件夹复制到 `public` 目录。

### Q2: 地图不显示？

检查：
1. OpenLayers CSS 是否正确引入
2. 地图容器是否有高度
3. 浏览器控制台是否有错误

### Q3: 天气API调用失败？

检查：
1. API Key 是否有效
2. 网络连接是否正常
3. 是否超过API调用限额

## 🔄 迁移步骤

如果你有现有的 HTML 文件需要迁移：

1. **提取样式** → 复制到 `assets/main.css`
2. **拆分组件** → 创建独立的 `.vue` 文件
3. **提取逻辑** → 使用 Composition API 重写
4. **配置路由** → 添加到 `router/index.js`
5. **测试功能** → 确保所有功能正常

## 📚 参考资料

- [Vue 3 文档](https://cn.vuejs.org/)
- [OpenLayers 文档](https://openlayers.org/en/latest/apidoc/)
- [OLTB 项目](https://github.com/qulle/oltb)
- [Vite 文档](https://cn.vitejs.dev/)

## 👥 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可

MIT License

---

**Made with ❤️ by 北京绿道系统开发团队**
