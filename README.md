# Beijing Greenway System Visualization Platform (Vue Version)

![Vue](https://img.shields.io/badge/Vue-3.4.0-brightgreen.svg)
![OpenLayers](https://img.shields.io/badge/OpenLayers-8.2.0-blue.svg)
![Vite](https://img.shields.io/badge/Vite-5.0-blueviolet.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

This is a modern WebGIS project built with **Vue 3 + OpenLayers + Vite**, designed to provide an intuitive and interactive platform for exploring and understanding Beijing's greenway network.

[中文文档](./README_zh-CN.md)

## ✨ Key Features

- **🗺️ Interactive Map**: A high-performance, full-screen map based on OpenLayers, supporting multiple base maps and layer overlays.
- **Layer Control**: Dynamically control the visibility of different geographical elements such as Beijing's boundary, greenways, and water systems.
- **📍 Information Query**: Click on a greenway on the map to query detailed information like its name, length, and description.
- **☀️ Real-time Weather**: Integrated with a weather API to provide real-time weather references for your travel planning.
- **Responsive Design**: Optimized for both desktop and mobile browsing experiences.
- **Modular Architecture**: Developed with a component-based approach and a clear module division for easy maintenance and extension.

## 🚀 Quick Start

1.  **Clone the repository**
    ```bash
    git clone https://github.com/yourusername/greenway-vue.git
    cd greenway-vue
    ```

2.  **Install dependencies**
    ```bash
    npm install
    ```

3.  **Start the development server**
    ```bash
    npm run dev
    ```
    The service will start at `http://localhost:5173`.

4.  **Build for production**
    ```bash
    npm run build
    ```
    The built files will be output to the `dist` directory.

## 🛠️ Tech Stack

- **Frontend Framework**: Vue 3 (Composition API)
- **Map Engine**: OpenLayers 8.2.0
- **Build Tool**: Vite 5.0.0
- **Routing**: Vue Router 4
- **HTTP Client**: Axios

## 📁 Project Structure

```
greenway-vue/
├── public/
│   └── data/            # GeoJSON spatial data
├── src/
│   ├── assets/          # Static assets (CSS, images)
│   ├── components/      # Reusable Vue components (Map, Weather Card, etc.)
│   ├── core/            # Core map management logic
│   ├── views/           # Page-level components
│   ├── router/          # Routing configuration
│   ├── App.vue          # Root component
│   └── main.js          # Application entry point
├── index.html
├── vite.config.js
└── package.json
```

## 🤝 Contributing

Pull Requests are welcome! If you have great ideas or suggestions, feel free to open an Issue for discussion.

1.  Fork this repository
2.  Create your new branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push your branch to the remote (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

This project is open-sourced under the [MIT License](./LICENSE).
