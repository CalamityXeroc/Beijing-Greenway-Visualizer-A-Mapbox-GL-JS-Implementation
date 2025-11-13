<template>
  <div class="greenroad-page">
    <header class="header">
      <h1>北京绿道系统可视化平台</h1>
      <p><i class="fas fa-map-marked-alt"></i> 探索城市绿色网络，享受健康生活</p>
    </header>

    <div class="map-container">
      <MapViewer
        ref="mapViewer"
        :center="mapConfig.center"
        :zoom="mapConfig.zoom"
        :layers="layers"
        height="100vh"
        @map-ready="onMapReady"
        @feature-click="onFeatureClick"
        @feature-hover="onFeatureHover"
      />
      
      <!-- 地图工具栏 -->
      <MapToolbar
        v-if="mapManager"
        :mapManager="mapManager"
        :layerConfig="layerConfig"
        @tool-activated="onToolActivated"
        @layer-added="onLayerAdded"
        @layer-toggled="onLayerToggled"
      />
    </div>

    <!-- 信息卡片区域 -->
    <div class="info-section">
      <div class="info-cards">
        <div class="info-card">
          <div class="info-card-header">
            <div class="info-card-icon">
              <i class="fas fa-route"></i>
            </div>
            <h2 class="info-card-title">系统概览</h2>
          </div>
          <div class="info-card-content">
            <p>北京市绿道系统串联起山、水、林、田等生态空间，形成贯通全市的绿色廊道网络。</p>
            <div class="stats-list">
              <div class="stat-item">
                <div class="stat-value">1000+</div>
                <div class="stat-label">总长度(km)</div>
              </div>
              <div class="stat-item">
                <div class="stat-value">16</div>
                <div class="stat-label">覆盖区域</div>
              </div>
              <div class="stat-item">
                <div class="stat-value">300+</div>
                <div class="stat-label">景点连接</div>
              </div>
            </div>
          </div>
        </div>

        <div class="info-card">
          <div class="info-card-header">
            <div class="info-card-icon" style="background: linear-gradient(135deg, #673AB7, #3F51B5);">
              <i class="fas fa-tree"></i>
            </div>
            <h2 class="info-card-title">绿道特色</h2>
          </div>
          <div class="info-card-content">
            <p>北京绿道系统整合了城市绿色资源，打造"山、水、城、景、文"五位一体的休闲游憩网络。</p>
            <div class="features-list">
              <span class="feature-tag">
                <i class="fas fa-mountain"></i>
                山地景观
              </span>
              <span class="feature-tag">
                <i class="fas fa-water"></i>
                滨水空间
              </span>
              <span class="feature-tag">
                <i class="fas fa-city"></i>
                城市风貌
              </span>
              <span class="feature-tag">
                <i class="fas fa-landmark"></i>
                文化遗产
              </span>
              <span class="feature-tag">
                <i class="fas fa-bicycle"></i>
                运动健身
              </span>
              <span class="feature-tag">
                <i class="fas fa-leaf"></i>
                生态保护
              </span>
            </div>
          </div>
        </div>

        <div class="info-card">
          <div class="info-card-header">
            <div class="info-card-icon" style="background: linear-gradient(135deg, #FF9800, #FF5722);">
              <i class="fas fa-info-circle"></i>
            </div>
            <h2 class="info-card-title">使用指南</h2>
          </div>
          <div class="info-card-content">
            <p>探索北京绿道系统，点击地图上的路线可以查看详细信息：</p>
            <ul class="guide-list">
              <li class="guide-item">
                <i class="fas fa-mouse-pointer"></i>
                <span>点击绿道路线查看详情</span>
              </li>
              <li class="guide-item">
                <i class="fas fa-search-plus"></i>
                <span>使用鼠标滚轮缩放地图</span>
              </li>
              <li class="guide-item">
                <i class="fas fa-hand-paper"></i>
                <span>拖动地图浏览不同区域</span>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <!-- 悬浮提示框 (Tooltip) -->
    <div v-if="tooltip.visible" class="hover-tooltip" :style="tooltipStyle">
      <div class="tooltip-header">
        <i class="fas fa-route"></i>
        <strong>{{ tooltip.title }}</strong>
      </div>
      <div class="tooltip-body">
        <div class="tooltip-item" v-if="tooltip.data.length">
          <i class="fas fa-ruler"></i>
          <span>总长度：{{ tooltip.data.length }} km</span>
        </div>
        <div class="tooltip-item" v-if="tooltip.data.area">
          <i class="fas fa-map-marked-alt"></i>
          <span>覆盖区域：{{ tooltip.data.area }}</span>
        </div>
        <div class="tooltip-item" v-if="tooltip.data.description">
          <i class="fas fa-info-circle"></i>
          <span>{{ tooltip.data.description }}</span>
        </div>
      </div>
      <div class="tooltip-footer">
        <small><i class="fas fa-mouse-pointer"></i> 点击查看详情</small>
      </div>
    </div>

    <!-- 弹窗 (点击后显示) -->
    <div v-if="popup.visible" class="popup" :style="popupStyle">
      <div class="popup-content" @mousedown="startDrag">
        <div class="popup-header">
          <h4>{{ popup.title }}</h4>
          <button class="popup-close" @click.stop="closePopup">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <p>{{ popup.content }}</p>
        <button @click.stop="viewPopupDetail" class="popup-btn">
          <i class="fas fa-external-link-alt"></i> 查看详情
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Style, Stroke } from 'ol/style'
import MapViewer from '@/components/MapViewer.vue'
import MapToolbar from '@/components/MapToolbar.vue'

const router = useRouter()

// 地图配置
const mapConfig = reactive({
  center: [116.4, 40.15],  // 稍微向北调整中心点
  zoom: 8.5  // 降低缩放级别，确保完整显示北京
})

// 图层配置
const layerConfig = ref([
  {
    id: 'beijing-area',
    name: '北京市域',
    type: 'geojson',
    url: '/数据/北京面.geojson',
    visible: true,
    zIndex: 5,
    style: {
      strokeColor: '#1976D2',
      strokeWidth: 3,
      fillColor: 'rgba(33, 150, 243, 0.15)'  // 更明显的蓝色填充
    }
  },
  {
    id: 'beijing-boundary',
    name: '市界',
    type: 'geojson',
    url: '/数据/北京边界.geojson',
    visible: true,
    zIndex: 6,
    style: {
      strokeColor: '#1565C0',
      strokeWidth: 4  // 加粗边界线
    }
  },
  {
    id: 'wenyu-greenway',
    name: '温榆河绿道',
    type: 'geojson',
    url: '/数据/绿道/温榆河绿道/温榆河.geojson',
    visible: true,
    zIndex: 10,
    fitExtent: false,  // 不自动适配，使用我们设置的初始视图
    style: {
      lineColor: '#4CAF50',
      lineWidth: 5  // 加粗绿道线条
    },
    info: {
      name: '温榆河绿道',
      description: '沿温榆河而建的滨水型绿道，全长108公里',
      length: 108,
      area: '昌平、顺义、朝阳、通州'
    }
  }
])

// 当前激活的图层
const layers = computed(() => {
  return layerConfig.value.map(layer => ({
    ...layer,
    visible: layer.visible !== false
  }))
})

// 选中的绿道
const selectedGreenway = ref(null)

// 悬浮提示框状态 (Tooltip - 鼠标悬停时显示)
const tooltip = reactive({
  visible: false,
  title: '',
  data: {},
  position: { x: 0, y: 0 }
})

const tooltipStyle = computed(() => ({
  left: `${tooltip.position.x + 15}px`,  // 偏移15px，避免遮挡鼠标
  top: `${tooltip.position.y + 15}px`
}))

// 弹窗状态 (Popup - 点击后显示)
const popup = reactive({
  visible: false,
  title: '',
  content: '',
  data: null,
  position: { x: 0, y: 0 }
})

const popupStyle = computed(() => ({
  left: `${popup.position.x}px`,
  top: `${popup.position.y}px`
}))

// 弹窗拖动相关
const isDragging = ref(false)
const dragOffset = ref({ x: 0, y: 0 })

const startDrag = (event) => {
  isDragging.value = true
  const rect = event.currentTarget.getBoundingClientRect()
  dragOffset.value = {
    x: event.clientX - rect.left,
    y: event.clientY - rect.top
  }
  document.addEventListener('mousemove', onDrag)
  document.addEventListener('mouseup', stopDrag)
}

const onDrag = (event) => {
  if (isDragging.value) {
    popup.position.x = event.clientX - dragOffset.value.x
    popup.position.y = event.clientY - dragOffset.value.y
  }
}

const stopDrag = () => {
  isDragging.value = false
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', stopDrag)
}

const mapViewer = ref(null)
const mapManager = ref(null)

// 地图就绪
const onMapReady = (map) => {
  console.log('[GreenwayOverview] 地图已就绪')
  // 获取 MapManager 实例
  if (mapViewer.value) {
    mapManager.value = mapViewer.value.getMapManager()
  }
}

// 当前悬停的要素
const hoveredFeature = ref(null)
// 当前选中（点击）的图层
const selectedLayer = ref(null)
const selectedLayerId = ref(null)

// 高亮整个图层的所有要素
const highlightLayer = (layerId, color, width, isHover = false) => {
  const mapViewerComponent = mapViewer.value
  if (!mapViewerComponent) return
  
  const mapManager = mapViewerComponent.getMapManager()
  if (!mapManager) return
  
  const layer = mapManager.getLayer(layerId)
  if (!layer) return
  
  const source = layer.getSource()
  const features = source.getFeatures()
  
  // 创建带阴影效果的高亮样式
  const highlightStyle = [
    // 外层阴影（模拟发光效果）
    new Style({
      stroke: new Stroke({
        color: isHover ? 'rgba(255, 215, 0, 0.4)' : 'rgba(255, 107, 53, 0.4)',
        width: width + 6,
        lineCap: 'round',
        lineJoin: 'round'
      }),
      zIndex: 1
    }),
    // 中层阴影
    new Style({
      stroke: new Stroke({
        color: isHover ? 'rgba(255, 215, 0, 0.6)' : 'rgba(255, 107, 53, 0.6)',
        width: width + 3,
        lineCap: 'round',
        lineJoin: 'round'
      }),
      zIndex: 2
    }),
    // 主线条
    new Style({
      stroke: new Stroke({
        color: color,
        width: width,
        lineCap: 'round',
        lineJoin: 'round'
      }),
      zIndex: 3
    })
  ]
  
  // 给所有要素设置高亮样式
  features.forEach(feature => {
    feature.setStyle(highlightStyle)
  })
  
  return { layer, features }
}

// 清除图层高亮
const clearLayerHighlight = (layerId) => {
  const mapViewerComponent = mapViewer.value
  if (!mapViewerComponent) return
  
  const mapManager = mapViewerComponent.getMapManager()
  if (!mapManager) return
  
  const layer = mapManager.getLayer(layerId)
  if (!layer) return
  
  const source = layer.getSource()
  const features = source.getFeatures()
  
  // 恢复默认样式
  features.forEach(feature => {
    feature.setStyle(undefined)
  })
}

// 要素点击
const onFeatureClick = ({ features, featuresWithLayers, pixel }) => {
  console.log('[GreenwayOverview] 点击事件:', { features, featuresWithLayers, pixel })
  
  if (featuresWithLayers && featuresWithLayers.length > 0) {
    // 只处理来自温榆河绿道图层的要素
    const greenwayFeature = featuresWithLayers.find(f => f.layerId === 'wenyu-greenway')
    
    if (!greenwayFeature) {
      console.log('[GreenwayOverview] 未点击到绿道图层')
      return
    }
    
    console.log('[GreenwayOverview] 点击到绿道:', greenwayFeature)
    
    // 清除之前选中的图层高亮
    if (selectedLayerId.value && selectedLayerId.value !== 'wenyu-greenway') {
      clearLayerHighlight(selectedLayerId.value)
    }
    
    // 高亮整个绿道图层（橙红色表示选中，第四个参数 false 表示是点击状态）
    highlightLayer('wenyu-greenway', '#FF6B35', 5, false)
    selectedLayerId.value = 'wenyu-greenway'

    // 查找对应的图层配置
    const layerInfo = layerConfig.value.find(l => l.id === 'wenyu-greenway')
    
    if (layerInfo && layerInfo.info) {
      selectedGreenway.value = layerInfo.info
      
      // 隐藏悬停提示框
      tooltip.visible = false
      
      // 显示弹窗
      popup.title = layerInfo.info.name
      popup.content = layerInfo.info.description
      popup.data = layerInfo
      popup.position = { x: pixel[0], y: pixel[1] }
      popup.visible = true
      
      console.log('[GreenwayOverview] 显示弹窗:', popup)
    }
  }
}

// 要素悬停
const onFeatureHover = ({ featuresWithLayers, pixel, coordinate }) => {
  // 如果已经有选中的图层，只显示tooltip，不改变高亮样式
  const isLayerSelected = selectedLayerId.value !== null
  
  if (featuresWithLayers && featuresWithLayers.length > 0) {
    // 只处理绿道图层
    const greenwayFeature = featuresWithLayers.find(f => f.layerId === 'wenyu-greenway')
    
    if (greenwayFeature) {
      // 查找绿道信息
      const layerInfo = layerConfig.value.find(l => l.id === 'wenyu-greenway')
      
      // 只有在弹窗未显示时才显示悬浮提示框
      if (layerInfo && layerInfo.info && !popup.visible) {
        tooltip.title = layerInfo.info.name
        tooltip.data = {
          length: layerInfo.info.length,
          area: layerInfo.info.area,
          description: layerInfo.info.description
        }
        tooltip.position = { x: pixel[0], y: pixel[1] }
        tooltip.visible = true
      }
      
      // 如果没有选中的图层，才更新高亮效果
      if (!isLayerSelected) {
        // 只有当悬停到不同的要素时才更新高亮
        if (greenwayFeature.feature !== hoveredFeature.value) {
          // 清除之前的高亮
          if (hoveredFeature.value) {
            clearLayerHighlight('wenyu-greenway')
          }
          
          // 高亮整个绿道图层（金色表示悬停，第四个参数 true 表示是悬停状态）
          hoveredFeature.value = greenwayFeature.feature
          highlightLayer('wenyu-greenway', '#FFD700', 6, true)
        }
      }
    } else {
      // 鼠标不在绿道图层上
      // 隐藏tooltip
      tooltip.visible = false
      
      // 如果没有选中的图层，清除悬停高亮
      if (!isLayerSelected && hoveredFeature.value) {
        clearLayerHighlight('wenyu-greenway')
        hoveredFeature.value = null
      }
    }
  } else {
    // 没有任何要素在鼠标下方
    // 隐藏tooltip
    tooltip.visible = false
    
    // 如果没有选中的图层，清除悬停高亮
    if (!isLayerSelected && hoveredFeature.value) {
      clearLayerHighlight('wenyu-greenway')
      hoveredFeature.value = null
    }
  }
}

// 切换图层
const toggleLayer = (layerId, visible) => {
  const layer = layerConfig.value.find(l => l.id === layerId)
  if (layer) {
    layer.visible = visible
    
    // 通知地图组件更新
    if (mapViewer.value) {
      mapViewer.value.setLayerVisibility(layerId, visible)
    }
  }
}

// 图层切换事件（来自工具栏）
const onLayerToggled = ({ layerId, visible }) => {
  toggleLayer(layerId, visible)
}

// 关闭弹窗
const closePopup = () => {
  popup.visible = false
  
  // 清除选中图层的高亮
  if (selectedLayerId.value) {
    clearLayerHighlight(selectedLayerId.value)
    selectedLayerId.value = null
  }
}

// 查看详情
const viewDetail = () => {
  if (selectedGreenway.value) {
    router.push('/wenyu')
  }
}

// 弹窗查看详情
const viewPopupDetail = () => {
  closePopup()
  router.push('/wenyu')
}

// 工具栏事件处理
const onToolActivated = (data) => {
  console.log('[GreenwayOverview] 工具激活:', data)
}

const onLayerAdded = (layerInfo) => {
  console.log('[GreenwayOverview] 图层已添加:', layerInfo)
}

onMounted(() => {
  console.log('[GreenwayOverview] 组件已挂载')
})
</script>

<style scoped>
.greenroad-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #E8F5E9 0%, #E3F2FD 50%, #F1F8E9 100%);
  padding-top: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
}

.header {
  background: transparent;
  backdrop-filter: none;
  color: #2c3e50;
  padding: 1.2rem 2rem;
  text-align: center;
  margin: 0;
  box-shadow: none;
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  flex-shrink: 0;
  pointer-events: none;
}

.header h1,
.header p {
  pointer-events: auto;
}

/* 删除顶部绿色装饰线 */

@keyframes gradientMove {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}

.header h1 {
  font-size: 2.2rem;
  margin: 0 0 0.3rem 0;
  background: linear-gradient(120deg, #1B5E20, #2E7D32, #4CAF50, #66BB6A);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  font-weight: 800;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3),
               0 4px 16px rgba(76, 175, 80, 0.4);
  filter: drop-shadow(0 2px 4px rgba(255, 255, 255, 0.8));
  letter-spacing: 3px;
}

.header p {
  color: #1B5E20;
  font-size: 1rem;
  font-weight: 600;
  margin: 0;
  text-shadow: 0 2px 4px rgba(255, 255, 255, 0.9),
               0 1px 2px rgba(0, 0, 0, 0.3);
}

.header i {
  color: #4CAF50;
  margin-right: 0.5rem;
  filter: drop-shadow(0 2px 4px rgba(255, 255, 255, 0.8))
          drop-shadow(0 2px 4px rgba(76, 175, 80, 0.6));
}

.map-container {
  position: relative;
  overflow: hidden;
  min-height: 100vh;
  flex-shrink: 0;
}

/* 弹窗样式 */
.popup {
  position: fixed;
  z-index: 1000;
  pointer-events: all;
  animation: popupSlideIn 0.3s ease-out;
}

@keyframes popupSlideIn {
  from {
    opacity: 0;
    transform: scale(0.9);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.popup-content {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.98), rgba(248, 255, 248, 0.98));
  backdrop-filter: blur(15px);
  border-radius: 16px;
  padding: 0;
  box-shadow: 0 8px 32px rgba(76, 175, 80, 0.25);
  border: 2px solid rgba(76, 175, 80, 0.2);
  min-width: 250px;
  max-width: 350px;
  position: relative;
  cursor: move;
  user-select: none;
}

.popup-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.25rem;
  border-bottom: 2px solid rgba(76, 175, 80, 0.1);
  background: linear-gradient(135deg, rgba(76, 175, 80, 0.05), rgba(33, 150, 243, 0.05));
  border-radius: 14px 14px 0 0;
  cursor: move;
}

.popup-header h4 {
  margin: 0;
  color: #2E7D32;
  font-size: 1.1rem;
  font-weight: 600;
}

.popup-content > p {
  padding: 1rem 1.25rem;
  margin: 0;
  color: #558B2F;
  font-size: 0.95rem;
  line-height: 1.5;
  cursor: default;
}

.popup-close {
  position: relative;
  top: auto;
  right: auto;
  background: transparent;
  border: none;
  cursor: pointer;
  font-size: 1.1rem;
  color: #558B2F;
  padding: 0.25rem 0.5rem;
  border-radius: 8px;
  transition: all 0.2s ease;
}

.popup-close:hover {
  background: rgba(244, 67, 54, 0.1);
  color: #D32F2F;
  transform: rotate(90deg);
}

.popup-btn {
  width: calc(100% - 2.5rem);
  margin: 0 1.25rem 1.25rem 1.25rem;
  padding: 0.75rem;
  background: linear-gradient(135deg, #4CAF50, #66BB6A);
  color: white;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  font-size: 0.95rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
}

.popup-btn:hover {
  background: linear-gradient(135deg, #388E3C, #4CAF50);
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(76, 175, 80, 0.4);
}

/* 信息卡片区域 */
.info-section {
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.5);
  border-radius: 0;
  margin: 0;
  backdrop-filter: blur(10px);
  flex-shrink: 0;
}

.info-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.5rem;
  max-width: 1400px;
  margin: 0 auto;
}

.info-card {
  background: rgba(255, 255, 255, 0.95);
  padding: 1.25rem;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  backdrop-filter: blur(10px);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.info-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
}

.info-card-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.75rem;
  padding-bottom: 0.75rem;
  border-bottom: 2px solid rgba(52, 152, 219, 0.1);
}

.info-card-icon {
  width: 42px;
  height: 42px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #4CAF50, #2196F3);
  border-radius: 12px;
  color: white;
  font-size: 1.3rem;
}

.info-card-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #2c3e50;
  margin: 0;
}

.info-card-content {
  color: #666;
  line-height: 1.6;
  font-size: 0.9rem;
}

.info-card-content p {
  margin: 0 0 0.75rem 0;
}

.stats-list {
  margin-top: 0.75rem;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 0.75rem;
}

.stat-item {
  background: rgba(52, 152, 219, 0.1);
  padding: 0.75rem;
  border-radius: 8px;
  text-align: center;
}

.stat-value {
  font-size: 1.5rem;
  font-weight: 700;
  color: #2196F3;
  margin-bottom: 0.25rem;
}

.stat-label {
  font-size: 0.75rem;
  color: #666;
  font-weight: 500;
}

.features-list {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-top: 0.75rem;
}

.feature-tag {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  padding: 0.5rem 0.75rem;
  background: linear-gradient(135deg, rgba(76, 175, 80, 0.1), rgba(33, 150, 243, 0.1));
  border: 1px solid rgba(76, 175, 80, 0.2);
  border-radius: 20px;
  font-size: 0.8rem;
  color: #2E7D32;
  transition: all 0.3s ease;
}

.feature-tag:hover {
  background: linear-gradient(135deg, rgba(76, 175, 80, 0.2), rgba(33, 150, 243, 0.2));
  transform: translateY(-2px);
  box-shadow: 0 2px 8px rgba(76, 175, 80, 0.2);
}

.feature-tag i {
  color: #4CAF50;
}

.guide-list {
  list-style: none;
  padding: 0;
  margin: 0.75rem 0 0 0;
}

.guide-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin: 0.75rem 0;
  padding: 0.5rem;
  background: rgba(52, 152, 219, 0.05);
  border-radius: 6px;
  transition: all 0.3s ease;
}

.guide-item:hover {
  background: rgba(52, 152, 219, 0.1);
  transform: translateX(5px);
}

.guide-item:nth-child(1) {
  background: rgba(33, 150, 243, 0.05);
}

.guide-item:nth-child(1):hover {
  background: rgba(33, 150, 243, 0.1);
}

.guide-item:nth-child(2) {
  background: rgba(76, 175, 80, 0.05);
}

.guide-item:nth-child(2):hover {
  background: rgba(76, 175, 80, 0.1);
}

.guide-item:nth-child(3) {
  background: rgba(255, 152, 0, 0.05);
}

.guide-item:nth-child(3):hover {
  background: rgba(255, 152, 0, 0.1);
}

.guide-item i {
  font-size: 1.1rem;
  min-width: 1.5rem;
}

.guide-item:nth-child(1) i {
  color: #2196F3;
}

.guide-item:nth-child(2) i {
  color: #4CAF50;
}

.guide-item:nth-child(3) i {
  color: #FF9800;
}

/* 响应式 */
@media (max-width: 1200px) {
  .info-cards {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .header {
    padding: 1rem;
  }

  .header h1 {
    font-size: 1.5rem;
  }

  .header p {
    font-size: 0.875rem;
  }
}

/* 悬停提示框 */
.hover-tooltip {
  position: fixed;
  z-index: 9999;
  pointer-events: none;
  background: rgba(255, 255, 255, 0.98);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
  padding: 0;
  min-width: 280px;
  max-width: 320px;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(76, 175, 80, 0.2);
  overflow: hidden;
  animation: tooltipFadeIn 0.2s ease-out;
}

@keyframes tooltipFadeIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.tooltip-header {
  background: linear-gradient(135deg, #4CAF50, #66BB6A);
  color: white;
  padding: 0.875rem 1rem;
  font-weight: 600;
  font-size: 1rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  border-bottom: 2px solid rgba(255, 255, 255, 0.2);
}

.tooltip-header i {
  font-size: 1.1rem;
}

.tooltip-body {
  padding: 1rem;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.tooltip-item {
  display: flex;
  align-items: flex-start;
  gap: 0.625rem;
  font-size: 0.875rem;
  color: #424242;
  line-height: 1.5;
}

.tooltip-item i {
  color: #4CAF50;
  font-size: 0.875rem;
  margin-top: 0.15rem;
  flex-shrink: 0;
}

.tooltip-item strong {
  color: #2E7D32;
  font-weight: 600;
  margin-right: 0.25rem;
}

.tooltip-footer {
  background: rgba(76, 175, 80, 0.08);
  padding: 0.625rem 1rem;
  font-size: 0.75rem;
  color: #666;
  text-align: center;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.375rem;
  border-top: 1px solid rgba(76, 175, 80, 0.1);
}

.tooltip-footer i {
  font-size: 0.875rem;
  color: #4CAF50;
}

/* 响应式调整 */
@media (max-width: 768px) {
  .hover-tooltip {
    min-width: 240px;
    max-width: 280px;
  }
  
  .tooltip-header {
    font-size: 0.9rem;
    padding: 0.75rem 0.875rem;
  }
  
  .tooltip-body {
    padding: 0.875rem;
    gap: 0.625rem;
  }
  
  .tooltip-item {
    font-size: 0.8125rem;
  }
}
</style>
