<template>
  <div class="map-toolbar" :class="{ 'toolbar-collapsed': collapsed }">
    <div class="toolbar-header">
      <h3><i class="fas fa-tools"></i> 地图工具</h3>
      <button class="collapse-btn" @click="toggleCollapse">
        <i :class="collapsed ? 'fas fa-chevron-down' : 'fas fa-chevron-up'"></i>
      </button>
    </div>

    <div v-if="!collapsed" class="toolbar-content">
      <!-- 绘制工具 -->
      <div class="tool-section">
        <h4><i class="fas fa-draw-polygon"></i> 绘制工具</h4>
        <div class="tool-buttons">
          <button 
            class="tool-btn"
            :class="{ active: activeTool === 'point' }"
            @click="activateDrawTool('point')"
            title="绘制点"
          >
            <i class="fas fa-map-pin"></i>
            <span>点</span>
          </button>
          <button 
            class="tool-btn"
            :class="{ active: activeTool === 'line' }"
            @click="activateDrawTool('line')"
            title="绘制线"
          >
            <i class="fas fa-minus"></i>
            <span>线</span>
          </button>
          <button 
            class="tool-btn"
            :class="{ active: activeTool === 'polygon' }"
            @click="activateDrawTool('polygon')"
            title="绘制多边形"
          >
            <i class="fas fa-draw-polygon"></i>
            <span>面</span>
          </button>
        </div>
      </div>

      <!-- 测量工具 -->
      <div class="tool-section">
        <h4><i class="fas fa-ruler"></i> 测量工具</h4>
        <div class="tool-buttons">
          <button 
            class="tool-btn"
            :class="{ active: activeTool === 'measure-length' }"
            @click="activateMeasureTool('length')"
            title="测量距离"
          >
            <i class="fas fa-ruler-horizontal"></i>
            <span>距离</span>
          </button>
          <button 
            class="tool-btn"
            :class="{ active: activeTool === 'measure-area' }"
            @click="activateMeasureTool('area')"
            title="测量面积"
          >
            <i class="fas fa-ruler-combined"></i>
            <span>面积</span>
          </button>
        </div>
      </div>

      <!-- 图层管理 -->
      <div class="tool-section">
        <h4><i class="fas fa-layer-group"></i> 图层控制</h4>
        <div class="base-layer-list">
          <div 
            v-for="layer in props.layerConfig" 
            :key="layer.id"
            class="base-layer-item"
          >
            <label class="layer-checkbox">
              <input 
                type="checkbox" 
                :checked="layer.visible !== false"
                @change="toggleBaseLayer(layer.id, $event.target.checked)"
              />
              <span>{{ layer.name }}</span>
            </label>
          </div>
        </div>
      </div>

      <!-- 自定义图层 -->
      <div class="tool-section">
        <h4><i class="fas fa-upload"></i> 自定义图层</h4>
        <div class="layer-controls">
          <button class="tool-btn-block" @click="showLayerUpload = !showLayerUpload">
            <i class="fas fa-upload"></i>
            <span>上传 GeoJSON</span>
          </button>
          <div v-if="showLayerUpload" class="upload-panel">
            <input 
              type="file" 
              ref="fileInput"
              accept=".geojson,.json"
              @change="handleFileUpload"
              style="display: none"
            />
            <button @click="$refs.fileInput.click()" class="upload-btn">
              <i class="fas fa-file-upload"></i>
              选择文件
            </button>
          </div>
          <div v-if="customLayers.length > 0" class="custom-layer-list">
            <div 
              v-for="(layer, index) in customLayers" 
              :key="index"
              class="layer-item"
            >
              <label class="layer-checkbox">
                <input 
                  type="checkbox" 
                  :checked="layer.visible"
                  @change="toggleCustomLayer(index)"
                />
                <span>{{ layer.name }}</span>
              </label>
              <button @click="removeCustomLayer(index)" class="delete-btn">
                <i class="fas fa-trash"></i>
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- 清除工具 -->
      <div class="tool-section">
        <h4><i class="fas fa-eraser"></i> 清除</h4>
        <div class="tool-buttons">
          <button class="tool-btn-danger" @click="clearDrawings">
            <i class="fas fa-trash-alt"></i>
            <span>清除绘制</span>
          </button>
          <button class="tool-btn-danger" @click="clearMeasurements">
            <i class="fas fa-ruler"></i>
            <span>清除测量</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import Draw from 'ol/interaction/Draw'
import { Vector as VectorLayer } from 'ol/layer'
import { Vector as VectorSource } from 'ol/source'
import { Style, Stroke, Fill, Circle as CircleStyle, Text } from 'ol/style'
import { getLength, getArea } from 'ol/sphere'
import { LineString, Polygon } from 'ol/geom'
import GeoJSON from 'ol/format/GeoJSON'

const props = defineProps({
  mapManager: {
    type: Object,
    required: true
  },
  layerConfig: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['tool-activated', 'layer-added', 'layer-toggled'])

// 状态
const collapsed = ref(false)
const activeTool = ref(null)
const showLayerUpload = ref(false)
const customLayers = ref([])

// 绘制相关
let drawInteraction = null
let drawLayer = null
let measureLayer = null
const fileInput = ref(null)

// 初始化图层
onMounted(() => {
  initDrawLayer()
  initMeasureLayer()
})

// 清理
onBeforeUnmount(() => {
  if (drawInteraction) {
    props.mapManager.getMap().removeInteraction(drawInteraction)
  }
})

// 折叠/展开工具栏
const toggleCollapse = () => {
  collapsed.value = !collapsed.value
}

// 初始化绘制图层
const initDrawLayer = () => {
  const source = new VectorSource()
  drawLayer = new VectorLayer({
    source: source,
    style: new Style({
      fill: new Fill({
        color: 'rgba(76, 175, 80, 0.2)'
      }),
      stroke: new Stroke({
        color: '#4CAF50',
        width: 3
      }),
      image: new CircleStyle({
        radius: 7,
        fill: new Fill({
          color: '#4CAF50'
        }),
        stroke: new Stroke({
          color: '#ffffff',
          width: 2
        })
      })
    }),
    zIndex: 100
  })
  props.mapManager.addLayer('draw-layer', drawLayer)
}

// 初始化测量图层
const initMeasureLayer = () => {
  const source = new VectorSource()
  measureLayer = new VectorLayer({
    source: source,
    style: (feature) => {
      const geometry = feature.getGeometry()
      const type = geometry.getType()
      let measurement = ''

      if (type === 'LineString') {
        measurement = formatLength(geometry)
      } else if (type === 'Polygon') {
        measurement = formatArea(geometry)
      }

      return new Style({
        fill: new Fill({
          color: 'rgba(33, 150, 243, 0.2)'
        }),
        stroke: new Stroke({
          color: '#2196F3',
          width: 3,
          lineDash: [10, 10]
        }),
        image: new CircleStyle({
          radius: 5,
          fill: new Fill({
            color: '#2196F3'
          })
        }),
        text: new Text({
          text: measurement,
          fill: new Fill({ color: '#000' }),
          stroke: new Stroke({ color: '#fff', width: 3 }),
          font: 'bold 14px sans-serif',
          offsetY: -15
        })
      })
    },
    zIndex: 101
  })
  props.mapManager.addLayer('measure-layer', measureLayer)
}

// 激活绘制工具
const activateDrawTool = (type) => {
  removeCurrentInteraction()
  
  const geometryType = type === 'point' ? 'Point' : 
                       type === 'line' ? 'LineString' : 'Polygon'
  
  activeTool.value = type
  
  drawInteraction = new Draw({
    source: drawLayer.getSource(),
    type: geometryType
  })
  
  props.mapManager.getMap().addInteraction(drawInteraction)
  
  drawInteraction.on('drawend', () => {
    emit('tool-activated', { type: 'draw', subType: type })
  })
}

// 激活测量工具
const activateMeasureTool = (type) => {
  removeCurrentInteraction()
  
  const geometryType = type === 'length' ? 'LineString' : 'Polygon'
  activeTool.value = `measure-${type}`
  
  drawInteraction = new Draw({
    source: measureLayer.getSource(),
    type: geometryType
  })
  
  props.mapManager.getMap().addInteraction(drawInteraction)
  
  drawInteraction.on('drawend', (event) => {
    const feature = event.feature
    const geometry = feature.getGeometry()
    
    let measurement
    if (type === 'length') {
      measurement = formatLength(geometry)
    } else {
      measurement = formatArea(geometry)
    }
    
    emit('tool-activated', { type: 'measure', subType: type, value: measurement })
  })
}

// 移除当前交互
const removeCurrentInteraction = () => {
  if (drawInteraction) {
    props.mapManager.getMap().removeInteraction(drawInteraction)
    drawInteraction = null
  }
  activeTool.value = null
}

// 格式化长度
const formatLength = (line) => {
  const length = getLength(line)
  if (length > 1000) {
    return Math.round((length / 1000) * 100) / 100 + ' km'
  }
  return Math.round(length * 100) / 100 + ' m'
}

// 格式化面积
const formatArea = (polygon) => {
  const area = getArea(polygon)
  if (area > 10000) {
    return Math.round((area / 1000000) * 100) / 100 + ' km²'
  }
  return Math.round(area * 100) / 100 + ' m²'
}

// 文件上传处理
const handleFileUpload = async (event) => {
  const file = event.target.files[0]
  if (!file) return
  
  try {
    const text = await file.text()
    const geojson = JSON.parse(text)
    
    const source = new VectorSource({
      features: new GeoJSON().readFeatures(geojson, {
        featureProjection: 'EPSG:3857'
      })
    })
    
    const layer = new VectorLayer({
      source: source,
      style: new Style({
        fill: new Fill({
          color: 'rgba(255, 152, 0, 0.2)'
        }),
        stroke: new Stroke({
          color: '#FF9800',
          width: 2
        }),
        image: new CircleStyle({
          radius: 6,
          fill: new Fill({
            color: '#FF9800'
          })
        })
      }),
      zIndex: 50
    })
    
    const layerId = `custom-layer-${Date.now()}`
    props.mapManager.addLayer(layerId, layer)
    
    customLayers.value.push({
      id: layerId,
      name: file.name.replace('.geojson', '').replace('.json', ''),
      visible: true,
      layer: layer
    })
    
    // 缩放到图层范围
    const extent = source.getExtent()
    props.mapManager.fitExtent(extent, { padding: [50, 50, 50, 50] })
    
    emit('layer-added', { name: file.name, layerId })
    showLayerUpload.value = false
    event.target.value = ''
  } catch (error) {
    alert('文件解析失败: ' + error.message)
  }
}

const toggleCustomLayer = (index) => {
  const layer = customLayers.value[index]
  layer.visible = !layer.visible
  layer.layer.setVisible(layer.visible)
}

const removeCustomLayer = (index) => {
  const layer = customLayers.value[index]
  props.mapManager.removeLayer(layer.id)
  customLayers.value.splice(index, 1)
}

// 切换基础图层
const toggleBaseLayer = (layerId, visible) => {
  emit('layer-toggled', { layerId, visible })
}

// 清除功能
const clearDrawings = () => {
  if (confirm('确定要清除所有绘制内容吗？')) {
    drawLayer.getSource().clear()
    removeCurrentInteraction()
  }
}

const clearMeasurements = () => {
  if (confirm('确定要清除所有测量结果吗？')) {
    measureLayer.getSource().clear()
    removeCurrentInteraction()
  }
}
</script>

<style scoped>
.map-toolbar {
  position: absolute;
  top: 1rem;
  right: 1rem;
  width: 220px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  box-shadow: 0 2px 16px rgba(0, 0, 0, 0.12);
  border: 1px solid rgba(76, 175, 80, 0.15);
  z-index: 1000;
  max-height: calc(100vh - 2rem);
  overflow-y: auto;
  transition: all 0.3s ease;
}

.map-toolbar.toolbar-collapsed {
  height: auto;
  overflow: visible;
}

.toolbar-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.75rem;
  border-bottom: 1px solid rgba(76, 175, 80, 0.15);
  background: linear-gradient(135deg, rgba(76, 175, 80, 0.05), rgba(33, 150, 243, 0.05));
}

.toolbar-header h3 {
  margin: 0;
  color: #2E7D32;
  font-size: 0.95rem;
  display: flex;
  align-items: center;
  gap: 0.4rem;
}

.toolbar-header h3 i {
  font-size: 0.9rem;
}

.collapse-btn {
  background: none;
  border: none;
  cursor: pointer;
  color: #4CAF50;
  font-size: 1rem;
  padding: 0.2rem;
  transition: transform 0.3s ease;
}

.collapse-btn:hover {
  transform: scale(1.1);
}

.toolbar-content {
  padding: 0.75rem;
}

.tool-section {
  margin-bottom: 1rem;
}

.tool-section:last-child {
  margin-bottom: 0;
}

.tool-section h4 {
  color: #558B2F;
  font-size: 0.85rem;
  margin-bottom: 0.5rem;
  display: flex;
  align-items: center;
  gap: 0.4rem;
  font-weight: 600;
}

.tool-section h4 i {
  font-size: 0.8rem;
}

.tool-buttons {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 0.4rem;
}

.tool-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.2rem;
  padding: 0.5rem 0.3rem;
  background: rgba(76, 175, 80, 0.05);
  border: 1px solid rgba(76, 175, 80, 0.2);
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
  color: #558B2F;
  font-size: 0.75rem;
}

.tool-btn:hover {
  background: rgba(76, 175, 80, 0.1);
  border-color: #4CAF50;
  transform: translateY(-1px);
}

.tool-btn.active {
  background: linear-gradient(135deg, #4CAF50, #66BB6A);
  color: white;
  border-color: #4CAF50;
  box-shadow: 0 2px 8px rgba(76, 175, 80, 0.3);
}

.tool-btn i {
  font-size: 1rem;
}

.tool-btn-block {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.4rem;
  padding: 0.6rem;
  background: linear-gradient(135deg, #4CAF50, #66BB6A);
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 0.8rem;
  font-weight: 600;
  transition: all 0.2s ease;
  margin-bottom: 0.5rem;
}

.tool-btn-block:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
}

.tool-btn-block i {
  font-size: 0.85rem;
}

.tool-btn-danger {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.4rem;
  padding: 0.6rem;
  background: rgba(244, 67, 54, 0.1);
  color: #D32F2F;
  border: 1px solid rgba(244, 67, 54, 0.3);
  border-radius: 8px;
  cursor: pointer;
  font-size: 0.8rem;
  transition: all 0.2s ease;
  margin-bottom: 0.4rem;
}

.tool-btn-danger:hover {
  background: rgba(244, 67, 54, 0.2);
  border-color: #F44336;
}

.tool-btn-danger i {
  font-size: 0.85rem;
}

.custom-layer-list {
  max-height: 150px;
  overflow-y: auto;
  margin-top: 0.4rem;
}

.layer-item {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  margin-bottom: 0.4rem;
}

.layer-checkbox {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 0.4rem;
  padding: 0.4rem;
  background: rgba(255, 152, 0, 0.05);
  border: 1px solid rgba(255, 152, 0, 0.2);
  border-radius: 6px;
  cursor: pointer;
  font-size: 0.75rem;
}

.layer-checkbox input {
  accent-color: #4CAF50;
  width: 14px;
  height: 14px;
}

.base-layer-list {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
}

.base-layer-item {
  background: rgba(76, 175, 80, 0.03);
  border-radius: 6px;
  transition: all 0.2s ease;
}

.base-layer-item:hover {
  background: rgba(76, 175, 80, 0.08);
}

.base-layer-item .layer-checkbox {
  background: transparent;
  border: none;
  padding: 0.5rem;
}

.delete-btn {
  padding: 0.4rem;
  background: rgba(244, 67, 54, 0.1);
  border: 1px solid rgba(244, 67, 54, 0.2);
  border-radius: 6px;
  cursor: pointer;
  color: #D32F2F;
  transition: all 0.2s ease;
  font-size: 0.75rem;
}

.delete-btn:hover {
  background: rgba(244, 67, 54, 0.2);
}

.delete-btn i {
  font-size: 0.7rem;
}

.upload-panel {
  margin-top: 0.4rem;
}

.upload-btn {
  width: 100%;
  padding: 0.6rem;
  background: rgba(255, 152, 0, 0.1);
  border: 2px dashed rgba(255, 152, 0, 0.5);
  border-radius: 8px;
  cursor: pointer;
  color: #F57C00;
  font-size: 0.8rem;
  transition: all 0.2s ease;
}

.upload-btn:hover {
  background: rgba(255, 152, 0, 0.2);
  border-color: #FF9800;
}

.upload-btn i {
  font-size: 0.85rem;
}

/* 滚动条样式 */
.map-toolbar::-webkit-scrollbar,
.custom-layer-list::-webkit-scrollbar {
  width: 6px;
}

.map-toolbar::-webkit-scrollbar-track,
.custom-layer-list::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.05);
  border-radius: 3px;
}

.map-toolbar::-webkit-scrollbar-thumb,
.custom-layer-list::-webkit-scrollbar-thumb {
  background: rgba(76, 175, 80, 0.3);
  border-radius: 3px;
}

.map-toolbar::-webkit-scrollbar-thumb:hover,
.custom-layer-list::-webkit-scrollbar-thumb:hover {
  background: rgba(76, 175, 80, 0.5);
}
</style>
