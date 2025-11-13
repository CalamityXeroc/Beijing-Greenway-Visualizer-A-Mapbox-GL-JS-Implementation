# Beijing Greenway System Visualization Platform

![Vue](https://img.shields.io/badge/Vue-3.4.0-brightgreen.svg)
![OpenLayers](https://img.shields.io/badge/OpenLayers-8.2.0-blue.svg)
![Vite](https://img.shields.io/badge/Vite-5.0-blueviolet.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

A modern, interactive WebGIS platform for exploring Beijing's extensive greenway network. Built with **Vue 3 + OpenLayers + Vite**, offering an intuitive interface to discover urban green corridors, ecological spaces, and recreational paths.

[中文文档](./README_zh-CN.md)

## ✨ Key Features

### 🗺️ Interactive Mapping
- **Full-Screen Map Experience**: High-performance OpenLayers rendering with smooth interactions
- **Multi-Layer Visualization**: Toggle between administrative boundaries, greenways, and ecological elements
- **Smart Layer Management**: Dynamic control over map layers with intuitive UI
- **Responsive Design**: Optimized for both desktop and mobile devices

### 🛠️ Advanced GIS Tools
- **Drawing Tools**: Create points, lines, and polygons directly on the map
- **Measurement Tools**: Accurately measure distances and areas
- **Custom Layer Upload**: Import your own GeoJSON data for analysis
- **Interactive Popups**: Click features to view detailed information with hover effects

### 🌈 Enhanced User Experience
- **Transparent Header**: Modern floating title overlay on the map
- **Collapsible Weather Widget**: Draggable, foldable real-time weather information
- **Smooth Animations**: Polished transitions and hover effects throughout
- **Information Cards**: Discover greenway statistics, features, and usage guides

### 🌄 360° Panoramic Views
- **Baidu Street View Integration**: Explore greenways through immersive panoramic imagery
- **Multiple Viewpoints**: Switch between different scenic spots along the route
- **Interactive Navigation**: Click to explore and navigate through panoramic scenes

### 🎯 Greenway Details
- **Wenyu River Greenway**: Detailed showcase of the 108km waterfront path
- **Rich Imagery**: Visual guides to greenway attractions and facilities
- **Comprehensive Info**: Coverage area, length, amenities, and highlights
- **Left-Right Layout**: Clean, organized information presentation with full-size map

## 🚀 Quick Start

### Prerequisites
- **Node.js**: 16.x or higher
- **npm**: 7.x or higher

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/CalamityXeroc/Beijing-Greenway-Visualizer-A-openlayer-JS-Implementation.git
cd greenway-vue
```

2. **Install dependencies**
```bash
npm install
```

3. **Start development server**
```bash
npm run dev
```

4. **Open in browser**
Navigate to `http://localhost:5173`

### Production Build

```bash
npm run build
```

Build files will be output to the `dist/` directory.

## 🛠️ Tech Stack

### Core Framework
- **Vue 3.4.0**: Progressive JavaScript framework with Composition API
- **Vue Router 4.2.5**: Official router for Vue.js
- **Vite 5.0.0**: Next-generation frontend build tool

### Mapping & GIS
- **OpenLayers 8.2.0**: High-performance web mapping library
  - Vector and raster layer support
  - Drawing and measurement interactions
  - GeoJSON format support
  - Custom styling and animations

### Additional Features
- **Axios 1.6.0**: Promise-based HTTP client for API requests
- **Baidu Maps API**: Integrated for panoramic street view experiences
- **Weather API**: Real-time weather data integration

## 📁 Project Structure

```
greenway-vue/
├── public/
│   └── 数据/              # GeoJSON spatial data
│       ├── 北京边界.geojson
│       ├── 北京面.geojson
│       └── 绿道/
│           └── 温榆河绿道/
├── src/
│   ├── components/        # Reusable Vue components
│   │   ├── MapViewer.vue         # Core map component
│   │   ├── MapToolbar.vue        # GIS toolset
│   │   ├── WeatherCard.vue       # Draggable weather widget
│   │   ├── BaiduPanoramaViewer.vue  # 360° panorama viewer
│   │   └── PanoramaViewer.vue    # Alternative panorama component
│   ├── views/             # Page components
│   │   ├── GreenwayOverview.vue  # Main overview page
│   │   └── WenyuDetail.vue       # Wenyu River detail page
│   ├── core/              # Core functionality
│   │   ├── MapManager.js         # Map management class
│   │   └── LayerManager.js       # Layer control logic
│   ├── router/            # Vue Router configuration
│   ├── App.vue            # Root component
│   └── main.js            # Application entry
├── index.html
├── vite.config.js
└── package.json
```

## 🎨 Feature Highlights

### Map Tools
- **Point Drawing**: Mark locations of interest
- **Line Drawing**: Trace routes and paths
- **Polygon Drawing**: Define areas and boundaries
- **Distance Measurement**: Calculate path lengths (meters/kilometers)
- **Area Measurement**: Calculate polygon areas (square meters/kilometers)
- **Layer Toggle**: Show/hide base layers and overlays

### Interactive Elements
- **Hover Tooltips**: Display greenway information on mouse hover
- **Click Popups**: Detailed information panels with animations
- **Draggable Windows**: Move information panels freely around the map
- **Collapsible Weather**: Minimize weather widget to save screen space

### Panoramic Experience
- **Virtual Tour**: Navigate through multiple viewpoints
- **Street-Level Views**: Real Baidu street imagery
- **Interactive Markers**: Click to jump between locations
- **Fullscreen Mode**: Immersive panoramic viewing

## 🗺️ Data Sources

Geospatial data visualized on the platform includes:
- Beijing administrative boundaries
- Wenyu River Greenway route (108km)
- Ecological zones and parks
- Weather station locations

**Data Format**: GeoJSON (WGS84 / EPSG:4326)

## 🌐 Browser Support

- **Chrome/Edge** (Recommended): Version 90+
- **Firefox**: Version 88+
- **Safari**: Version 14+

## 🤝 Contributing

Contributions are welcome! Feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## 🙏 Acknowledgments

- Beijing Municipal Planning and Natural Resources Commission for greenway data
- OpenLayers community for excellent mapping library
- Vue.js team for the outstanding framework
- Baidu Maps for panoramic imagery services

## 📧 Contact

Project Link: [https://github.com/CalamityXeroc/Beijing-Greenway-Visualizer-A-openlayer-JS-Implementation](https://github.com/CalamityXeroc/Beijing-Greenway-Visualizer-A-openlayer-JS-Implementation)

---

**Built with ❤️ to explore Beijing's green spaces**
