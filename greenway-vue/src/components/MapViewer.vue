<template>
  <div ref="mapContainer" class="map-viewer" :style="{ height: height }"></div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, watch, nextTick } from 'vue'

const props = defineProps({
  // 地图配置
  center: {
    type: Array,
    default: () => [116.5, 40]
  },
  zoom: {
    type: Number,
    default: 10
  },
  height: {
    type: String,
    default: '100%'
  },
  // 底图配置
  baseLayerStyle: {
    type: Number,
    default: 8 // 高德地图样式
  },
  // 图层数据
  layers: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits([
  'map-ready',
  'map-click',
  'feature-click',
  'feature-hover',
  'center-changed',
  'zoom-changed'
])

const mapContainer = ref(null)

let map = null
let mapManager = null
let layerManager = null
let loadedLayers = new Map()

// 初始化地图
onMounted(async () => {
  await nextTick()
  
  // 直接创建实例，不用单例
  const MapManagerClass = (await import('@/core/MapManager')).default
  const LayerManagerClass = (await import('@/core/LayerManager')).default
  
  mapManager = new MapManagerClass()
  layerManager = new LayerManagerClass()
  
  // 初始化地图实例
  map = mapManager.init(mapContainer.value, {
    center: props.center,
    zoom: props.zoom
  })

  // 添加底图
  const baseLayer = layerManager.createGaodeLayer(props.baseLayerStyle)
  mapManager.addLayer('base', baseLayer)

  // 加载初始图层
  if (props.layers && props.layers.length > 0) {
    await loadLayers(props.layers)
  }

  // 注册事件监听
  setupEventListeners()

  // 通知父组件地图已就绪
  emit('map-ready', map)
  
  console.log('[MapViewer] 地图组件初始化完成')
})

// 监听图层数据变化
watch(() => props.layers, async (newLayers) => {
  if (newLayers && map && mapManager) {
    // 清除旧图层
    loadedLayers.forEach((layer, id) => {
      if (id !== 'base') {
        mapManager.removeLayer(id)
      }
    })
    loadedLayers.clear()

    // 加载新图层
    await loadLayers(newLayers)
  }
}, { deep: true })

// 加载图层
async function loadLayers(layersConfig) {
  if (!layerManager || !mapManager) return
  
  for (const config of layersConfig) {
    try {
      let layer = null

      if (config.type === 'geojson') {
        // 从 URL 或数据加载 GeoJSON 图层
        layer = layerManager.createVectorLayerFromGeoJSON({
          url: config.url,
          data: config.data,
          style: config.style ? layerManager.createStyleFunction(config.style) : undefined,
          zIndex: config.zIndex || 10,
          visible: config.visible !== false
        })
      } else if (config.type === 'vector') {
        // 创建空的矢量图层
        layer = layerManager.createVectorLayerFromFeatures([], {
          style: config.style ? layerManager.createStyleFunction(config.style) : undefined,
          zIndex: config.zIndex || 10,
          visible: config.visible !== false
        })
      }

      if (layer) {
        const layerId = config.id || `layer-${Date.now()}`
        mapManager.addLayer(layerId, layer)
        loadedLayers.set(layerId, layer)

        // 如果需要自适应范围
        if (config.fitExtent) {
          const source = layer.getSource()
          source.once('change', () => {
            if (source.getState() === 'ready') {
              const extent = source.getExtent()
              mapManager.fitExtent(extent)
            }
          })
        }
      }
    } catch (error) {
      console.error(`[MapViewer] 加载图层失败:`, config, error)
    }
  }
}

// 设置事件监听器
function setupEventListeners() {
  if (!mapManager) return
  
  // 点击事件
  mapManager.on('click', (evt) => {
    emit('map-click', {
      coordinate: evt.coordinate,
      pixel: evt.pixel
    })

    // 检测是否点击到要素，并获取图层信息
    const featuresWithLayers = []
    map.forEachFeatureAtPixel(evt.pixel, (feature, layer) => {
      // 找到对应的图层ID
      let layerId = null
      loadedLayers.forEach((l, id) => {
        if (l === layer) {
          layerId = id
        }
      })
      
      featuresWithLayers.push({
        feature: feature,
        layer: layer,
        layerId: layerId
      })
    })
    
    if (featuresWithLayers.length > 0) {
      emit('feature-click', {
        features: featuresWithLayers.map(f => f.feature),
        featuresWithLayers: featuresWithLayers,
        coordinate: evt.coordinate,
        pixel: evt.pixel
      })
    }
  })

  // 鼠标移动事件
  mapManager.on('pointermove', (evt) => {
    const featuresWithLayers = []
    map.forEachFeatureAtPixel(evt.pixel, (feature, layer) => {
      let layerId = null
      loadedLayers.forEach((l, id) => {
        if (l === layer) {
          layerId = id
        }
      })
      
      featuresWithLayers.push({
        feature: feature,
        layer: layer,
        layerId: layerId
      })
    })
    
    // 修改鼠标样式
    map.getTargetElement().style.cursor = featuresWithLayers.length > 0 ? 'pointer' : ''

    if (featuresWithLayers.length > 0) {
      emit('feature-hover', {
        features: featuresWithLayers.map(f => f.feature),
        featuresWithLayers: featuresWithLayers,
        coordinate: evt.coordinate,
        pixel: evt.pixel
      })
    }
  })

  // 视图变化事件
  const view = mapManager.getView()
  view.on('change:center', () => {
    emit('center-changed', mapManager.getCenter())
  })

  view.on('change:resolution', () => {
    emit('zoom-changed', view.getZoom())
  })
}

// 暴露方法供父组件调用
defineExpose({
  getMap: () => map,
  getMapManager: () => mapManager,
  getLayerManager: () => layerManager,
  setCenter: (lonLat, zoom) => mapManager?.setCenter(lonLat, zoom),
  fitExtent: (extent, options) => mapManager?.fitExtent(extent, options),
  addLayer: (id, layer) => {
    if (mapManager) {
      mapManager.addLayer(id, layer)
      loadedLayers.set(id, layer)
    }
  },
  removeLayer: (id) => {
    if (mapManager) {
      mapManager.removeLayer(id)
      loadedLayers.delete(id)
    }
  },
  setLayerVisibility: (id, visible) => mapManager?.setLayerVisibility(id, visible)
})

// 清理
onBeforeUnmount(() => {
  loadedLayers.clear()
  // 注意：不要销毁全局的 mapManager，因为可能被其他组件使用
  console.log('[MapViewer] 组件卸载')
})
</script>

<style scoped>
.map-viewer {
  width: 100%;
  position: relative;
  border-radius: 16px;
  overflow: hidden;
}

/* OpenLayers 控件样式优化 */
:deep(.ol-control) {
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

:deep(.ol-control button) {
  background: transparent;
  transition: all 0.2s ease;
}

:deep(.ol-control button:hover) {
  background: rgba(33, 150, 243, 0.1);
}

:deep(.ol-zoom) {
  top: 1rem;
  left: auto;
  right: 1rem;
}

:deep(.ol-attribution) {
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
}
</style>
