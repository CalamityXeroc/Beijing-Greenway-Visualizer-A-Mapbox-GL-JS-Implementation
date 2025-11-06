<template>
  <div class="greenroad-page">
    <header class="header">
      <h1>北京绿道系统总览</h1>
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

    <!-- 弹窗 -->
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

// 弹窗状态
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
const highlightLayer = (layerId, color, width) => {
  const mapViewerComponent = mapViewer.value
  if (!mapViewerComponent) return
  
  const mapManager = mapViewerComponent.getMapManager()
  if (!mapManager) return
  
  const layer = mapManager.getLayer(layerId)
  if (!layer) return
  
  const source = layer.getSource()
  const features = source.getFeatures()
  
  // 创建高亮样式
  const highlightStyle = new Style({
    stroke: new Stroke({
      color: color,
      width: width
    })
  })
  
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
    
    // 高亮整个绿道图层（橙红色表示选中）
    highlightLayer('wenyu-greenway', '#FF6B35', 5)
    selectedLayerId.value = 'wenyu-greenway'

    // 查找对应的图层配置
    const layerInfo = layerConfig.value.find(l => l.id === 'wenyu-greenway')
    
    if (layerInfo && layerInfo.info) {
      selectedGreenway.value = layerInfo.info
      
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
const onFeatureHover = ({ featuresWithLayers }) => {
  // 如果已经有选中的图层，悬停不改变样式
  if (selectedLayerId.value) {
    return
  }
  
  if (featuresWithLayers && featuresWithLayers.length > 0) {
    // 只处理绿道图层
    const greenwayFeature = featuresWithLayers.find(f => f.layerId === 'wenyu-greenway')
    
    if (greenwayFeature && greenwayFeature.feature !== hoveredFeature.value) {
      // 清除之前的高亮
      if (hoveredFeature.value) {
        clearLayerHighlight('wenyu-greenway')
      }
      
      // 高亮整个绿道图层（金色表示悬停）
      hoveredFeature.value = greenwayFeature.feature
      highlightLayer('wenyu-greenway', '#FFD700', 6)
    }
  } else {
    // 清除悬停高亮
    if (hoveredFeature.value) {
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
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(15px);
  color: #2c3e50;
  padding: 0.75rem 1.5rem;
  text-align: center;
  margin: 0;
  box-shadow: 0 2px 12px rgba(76, 175, 80, 0.15);
  position: relative;
  z-index: 10;
  flex-shrink: 0;
}

/* 删除顶部绿色装饰线 */

@keyframes gradientMove {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}

.header h1 {
  font-size: 1.5rem;
  margin: 0 0 0.15rem 0;
  background: linear-gradient(120deg, #2E7D32, #4CAF50, #66BB6A);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  font-weight: 700;
  text-shadow: 0 2px 10px rgba(76, 175, 80, 0.1);
}

.header p {
  color: #558B2F;
  font-size: 0.85rem;
  font-weight: 500;
  margin: 0;
}

.header i {
  color: #4CAF50;
  margin-right: 0.5rem;
  filter: drop-shadow(0 2px 4px rgba(76, 175, 80, 0.3));
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
</style>
