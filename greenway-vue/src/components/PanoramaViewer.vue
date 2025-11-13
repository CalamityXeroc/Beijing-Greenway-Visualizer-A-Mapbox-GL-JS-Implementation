<template>
  <div class="panorama-viewer-wrapper" v-if="visible">
    <div class="panorama-overlay" @click="closeViewer"></div>
    <div class="panorama-container">
      <!-- 头部控制栏 -->
      <div class="panorama-header">
        <div class="panorama-title">
          <i class="fas fa-street-view"></i>
          <span>{{ currentPoint.name }}</span>
        </div>
        <div class="panorama-controls">
          <button 
            class="control-btn" 
            @click="toggleFullscreen"
            title="全屏"
          >
            <i :class="isFullscreen ? 'fas fa-compress' : 'fas fa-expand'"></i>
          </button>
          <button 
            class="control-btn close-btn" 
            @click="closeViewer"
            title="关闭"
          >
            <i class="fas fa-times"></i>
          </button>
        </div>
      </div>

      <!-- 全景容器 -->
      <div ref="viewerContainer" class="panorama-content"></div>

      <!-- 底部导航 -->
      <div class="panorama-footer">
        <div class="points-navigation">
          <button 
            v-for="(point, index) in panoramaPoints" 
            :key="index"
            class="point-btn"
            :class="{ active: currentPointIndex === index }"
            @click="switchPoint(index)"
            :title="point.name"
          >
            <i class="fas fa-map-marker-alt"></i>
            <span>{{ point.name }}</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, watch, computed } from 'vue'
import { Viewer } from '@photo-sphere-viewer/core'
import { MarkersPlugin } from '@photo-sphere-viewer/markers-plugin'
import '@photo-sphere-viewer/core/index.css'
import '@photo-sphere-viewer/markers-plugin/index.css'

const props = defineProps({
  visible: {
    type: Boolean,
    default: false
  },
  panoramaPoints: {
    type: Array,
    default: () => []
  },
  initialPoint: {
    type: Number,
    default: 0
  }
})

const emit = defineEmits(['close', 'point-change'])

const viewerContainer = ref(null)
const currentPointIndex = ref(props.initialPoint)
const isFullscreen = ref(false)
let viewer = null

const currentPoint = computed(() => {
  return props.panoramaPoints[currentPointIndex.value] || { name: '全景浏览', image: '' }
})

// 初始化查看器
const initViewer = () => {
  if (!viewerContainer.value || !currentPoint.value.image) return

  try {
    viewer = new Viewer({
      container: viewerContainer.value,
      panorama: currentPoint.value.image,
      caption: currentPoint.value.description,
      navbar: [
        'zoom',
        'move',
        'download',
        'caption',
        'fullscreen',
      ],
      defaultZoomLvl: 50,
      mousewheel: true,
      mousemove: true,
      keyboard: 'fullscreen',
      fisheye: false,
      minFov: 30,
      maxFov: 90,
      defaultYaw: 0,
      defaultPitch: 0,
      plugins: [
        [MarkersPlugin, {
          markers: currentPoint.value.markers || []
        }]
      ]
    })

    // 监听加载完成
    viewer.addEventListener('ready', () => {
      console.log('[全景] 加载成功:', currentPoint.value.name)
    })

    // 监听错误
    viewer.addEventListener('panorama-error', (err) => {
      console.error('[全景] 加载失败:', err)
      console.error('[全景] 图片URL:', currentPoint.value.image)
      alert(`全景图加载失败！\n\n可能原因：\n1. 图片URL不可访问\n2. 图片格式不正确（需要2:1比例的等距柱状投影）\n3. 网络连接问题\n\n当前URL: ${currentPoint.value.image}`)
    })

    // 监听加载进度
    viewer.addEventListener('panorama-load-progress', (progress) => {
      console.log('[全景] 加载进度:', Math.round(progress.loaded * 100) + '%')
    })

  } catch (error) {
    console.error('[全景] 初始化失败:', error)
    alert(`全景查看器初始化失败！\n\n错误信息：${error.message}\n\n请刷新页面重试。`)
  }
}

// 切换观景点
const switchPoint = (index) => {
  if (index === currentPointIndex.value || !viewer) return
  
  currentPointIndex.value = index
  const point = props.panoramaPoints[index]
  
  viewer.setPanorama(point.image, {
    transition: 1500,
    caption: point.description
  }).then(() => {
    // 更新标记点
    const markersPlugin = viewer.getPlugin(MarkersPlugin)
    if (markersPlugin && point.markers) {
      markersPlugin.clearMarkers()
      point.markers.forEach(marker => {
        markersPlugin.addMarker(marker)
      })
    }
    emit('point-change', index)
  })
}

// 切换全屏
const toggleFullscreen = () => {
  if (!viewer) return
  viewer.toggleFullscreen()
  isFullscreen.value = !isFullscreen.value
}

// 关闭查看器
const closeViewer = () => {
  emit('close')
}

// 销毁查看器
const destroyViewer = () => {
  if (viewer) {
    viewer.destroy()
    viewer = null
  }
}

// 监听可见性变化
watch(() => props.visible, (newVal) => {
  if (newVal) {
    // 延迟初始化，确保 DOM 已渲染
    setTimeout(() => {
      initViewer()
    }, 100)
  } else {
    destroyViewer()
  }
})

onMounted(() => {
  if (props.visible) {
    initViewer()
  }
})

onBeforeUnmount(() => {
  destroyViewer()
})

// 键盘控制
const handleKeydown = (e) => {
  if (!props.visible) return
  
  if (e.key === 'Escape') {
    closeViewer()
  } else if (e.key === 'ArrowLeft') {
    const prevIndex = currentPointIndex.value > 0 ? currentPointIndex.value - 1 : props.panoramaPoints.length - 1
    switchPoint(prevIndex)
  } else if (e.key === 'ArrowRight') {
    const nextIndex = currentPointIndex.value < props.panoramaPoints.length - 1 ? currentPointIndex.value + 1 : 0
    switchPoint(nextIndex)
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeydown)
})

onBeforeUnmount(() => {
  window.removeEventListener('keydown', handleKeydown)
})
</script>

<style scoped>
.panorama-viewer-wrapper {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 10000;
  display: flex;
  align-items: center;
  justify-content: center;
}

.panorama-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.95);
  animation: fadeIn 0.3s ease;
}

.panorama-container {
  position: relative;
  width: 95%;
  height: 95%;
  max-width: 1800px;
  max-height: 1000px;
  background: #000;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.8);
  display: flex;
  flex-direction: column;
  z-index: 1;
  animation: slideUp 0.4s ease;
}

.panorama-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.5rem;
  background: linear-gradient(135deg, #1a1a1a, #2d2d2d);
  border-bottom: 2px solid #4CAF50;
}

.panorama-title {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  color: #fff;
  font-size: 1.2rem;
  font-weight: 600;
}

.panorama-title i {
  color: #4CAF50;
  font-size: 1.5rem;
}

.panorama-controls {
  display: flex;
  gap: 0.5rem;
}

.control-btn {
  padding: 0.5rem 1rem;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 6px;
  color: #fff;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 1rem;
}

.control-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  border-color: #4CAF50;
  transform: translateY(-2px);
}

.close-btn:hover {
  background: #f44336;
  border-color: #f44336;
}

.panorama-content {
  flex: 1;
  width: 100%;
  position: relative;
  background: #000;
}

.panorama-footer {
  padding: 1rem;
  background: linear-gradient(135deg, #1a1a1a, #2d2d2d);
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.points-navigation {
  display: flex;
  gap: 0.75rem;
  overflow-x: auto;
  padding: 0.5rem 0;
}

.points-navigation::-webkit-scrollbar {
  height: 6px;
}

.points-navigation::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.05);
  border-radius: 3px;
}

.points-navigation::-webkit-scrollbar-thumb {
  background: #4CAF50;
  border-radius: 3px;
}

.point-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.25rem;
  background: rgba(255, 255, 255, 0.05);
  border: 2px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: #fff;
  cursor: pointer;
  transition: all 0.3s ease;
  white-space: nowrap;
  font-size: 0.95rem;
}

.point-btn i {
  color: #4CAF50;
}

.point-btn:hover {
  background: rgba(76, 175, 80, 0.2);
  border-color: #4CAF50;
  transform: translateY(-2px);
}

.point-btn.active {
  background: linear-gradient(135deg, #4CAF50, #45a049);
  border-color: #4CAF50;
  box-shadow: 0 4px 12px rgba(76, 175, 80, 0.4);
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .panorama-container {
    width: 100%;
    height: 100%;
    max-width: 100%;
    max-height: 100%;
    border-radius: 0;
  }

  .panorama-header {
    padding: 0.75rem 1rem;
  }

  .panorama-title {
    font-size: 1rem;
  }

  .panorama-title span {
    display: none;
  }

  .points-navigation {
    gap: 0.5rem;
  }

  .point-btn span {
    display: none;
  }

  .point-btn {
    padding: 0.75rem;
  }
}
</style>
