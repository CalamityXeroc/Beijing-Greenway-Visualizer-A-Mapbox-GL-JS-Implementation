<template>
  <div class="wenyu-page">
    <header class="header">
      <button @click="goBack" class="back-btn">
        <i class="fas fa-arrow-left"></i> 返回
      </button>
      <h1>北京温榆河滨水绿道</h1>
      <p><i class="fas fa-leaf"></i> 沿河而行，探索城市绿色长廊</p>
    </header>

    <div class="content">
      <div class="info-section">
        <img 
          src="/数据/绿道/温榆河绿道/温榆河风景.jpg" 
          alt="温榆河绿道景观" 
          class="feature-image"
          @error="handleImageError"
        />
        
        <div class="highlights">
          <h3><i class="fas fa-star"></i>绿道亮点</h3>
          <ul>
            <li>
              <strong>总长度：</strong>
              <span>108公里</span>
            </li>
            <li>
              <strong>覆盖区域：</strong>
              <span>昌平、顺义、朝阳、通州四区</span>
            </li>
            <li>
              <strong>建设面积：</strong>
              <span>417公顷</span>
            </li>
            <li>
              <strong>特色：</strong>
              <span>滨水生态景观、休闲步道系统</span>
            </li>
          </ul>
        </div>
      </div>

      <div class="map-info-section">
        <MapViewer
          ref="mapViewer"
          :center="mapConfig.center"
          :zoom="mapConfig.zoom"
          :layers="layers"
          height="500px"
          @map-ready="onMapReady"
        />

        <WeatherCard
          v-if="weatherLocation"
          :longitude="weatherLocation.lon"
          :latitude="weatherLocation.lat"
          @weather-loaded="onWeatherLoaded"
        />

        <div class="highlights">
          <h3><i class="fas fa-info-circle"></i>绿道简介</h3>
          <p class="description">
            温榆河滨水绿道是北京市级滨水型绿道，发源于昌平区军都山麓，
            自沙河水库至通州区北关拦河闸段为大运河上游。沿线串联多个生态景观节点，
            包括巩华城、沙河闸公园、未来科技城滨水公园等，是市民休闲游憩的绝佳去处。
          </p>
          <div class="badges">
            <span class="badge badge-green">
              <i class="fas fa-tree"></i> 生态景观
            </span>
            <span class="badge badge-blue">
              <i class="fas fa-water"></i> 滨水休闲
            </span>
            <span class="badge badge-purple">
              <i class="fas fa-bicycle"></i> 运动健身
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import MapViewer from '@/components/MapViewer.vue'
import WeatherCard from '@/components/WeatherCard.vue'

const router = useRouter()

// 地图组件引用
const mapViewer = ref(null)

// 地图配置
const mapConfig = reactive({
  center: [116.5, 40],
  zoom: 10
})

// 天气位置
const weatherLocation = ref(null)

// 图层配置
const layers = ref([
  {
    id: 'wenyu-greenway',
    type: 'geojson',
    url: '/数据/绿道/温榆河绿道/温榆河.geojson',
    visible: true,
    fitExtent: true,
    style: {
      lineColor: '#2196F3',
      lineWidth: 4
    }
  }
])

// 地图就绪
const onMapReady = (map) => {
  console.log('[WenyuDetail] 地图已就绪')
  
  // 获取地图中心作为天气查询位置
  setTimeout(() => {
    if (mapViewer.value) {
      const mapMgr = mapViewer.value.getMapManager()
      const center = mapMgr.getCenter()
      weatherLocation.value = {
        lon: center[0],
        lat: center[1]
      }
      console.log('[WenyuDetail] 天气查询位置:', weatherLocation.value)
    }
  }, 1000)
}

// 天气加载完成
const onWeatherLoaded = (weather) => {
  console.log('[WenyuDetail] 天气数据已加载:', weather)
}

// 返回上一页
const goBack = () => {
  router.back()
}

// 图片加载失败处理
const handleImageError = (event) => {
  console.warn('[WenyuDetail] 图片加载失败')
  event.target.src = 'https://via.placeholder.com/800x300?text=温榆河绿道'
}

onMounted(() => {
  console.log('[WenyuDetail] 组件已挂载')
})
</script>

<style scoped>
.wenyu-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #E8F5E9 0%, #E3F2FD 50%, #F1F8E9 100%);
  padding-top: 0;
  margin: 0;
}

.header {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(15px);
  color: #2c3e50;
  padding: 1rem 1.5rem;
  text-align: center;
  margin: 0;
  box-shadow: 0 2px 12px rgba(76, 175, 80, 0.15);
  position: relative;
  overflow: hidden;
  border-bottom: 2px solid rgba(76, 175, 80, 0.1);
}

/* 删除顶部绿色装饰线 */

.back-btn {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  left: 1.5rem;
  background: rgba(33, 150, 243, 0.1);
  border: none;
  padding: 0.4rem 0.8rem;
  border-radius: 8px;
  cursor: pointer;
  font-size: 0.9rem;
  color: #2196F3;
  display: flex;
  align-items: center;
  gap: 0.4rem;
  transition: all 0.2s;
}

.back-btn:hover {
  background: rgba(33, 150, 243, 0.2);
  transform: translateY(-50%) translateX(-2px);
}

.header h1 {
  font-size: 1.5rem;
  margin: 0 0 0.15rem 0;
  background: linear-gradient(120deg, #2E7D32, #4CAF50, #66BB6A);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  font-weight: 700;
}

.header p {
  color: #558B2F;
  font-size: 0.85rem;
  font-weight: 500;
  margin: 0;
}

.header i {
  color: #4CAF50;
  margin-right: 0.4rem;
}

.content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 2rem 2rem 2rem;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
}

.info-section,
.map-info-section {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  position: relative;  /* 为工具栏定位提供参考 */
}

.info-section {
  padding: 2rem;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
}

.info-section:hover {
  transform: translateY(-5px);
}

.feature-image {
  width: 100%;
  height: 300px;
  object-fit: cover;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
}

.feature-image:hover {
  transform: scale(1.02);
}

.highlights {
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  padding: 1.5rem;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.highlights h3 {
  color: #2196F3;
  margin-bottom: 1rem;
  font-size: 1.3rem;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.highlights h3::before {
  content: '';
  display: block;
  width: 4px;
  height: 1em;
  background: linear-gradient(180deg, #4CAF50, #2196F3);
  border-radius: 2px;
}

.highlights ul {
  list-style-type: none;
  padding: 0;
}

.highlights li {
  margin: 0.75rem 0;
  padding: 0.75rem 1rem 0.75rem 2.5rem;
  position: relative;
  background: rgba(255, 255, 255, 0.5);
  border-radius: 8px;
  transition: all 0.2s ease;
}

.highlights li:hover {
  transform: translateX(5px);
  background: rgba(255, 255, 255, 0.8);
}

.highlights li::before {
  content: "\f058";
  font-family: "Font Awesome 6 Free";
  font-weight: 900;
  color: #4CAF50;
  position: absolute;
  left: 0.8rem;
  opacity: 0.8;
}

.highlights li strong {
  color: #2196F3;
}

.highlights li span {
  color: #666;
}

.description {
  line-height: 1.8;
  color: #666;
  margin-bottom: 1rem;
}

.badges {
  display: flex;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.badge {
  padding: 0.4rem 0.8rem;
  border-radius: 20px;
  font-size: 0.9rem;
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
}

.badge-green {
  background: rgba(76, 175, 80, 0.1);
  color: #4CAF50;
}

.badge-blue {
  background: rgba(33, 150, 243, 0.1);
  color: #2196F3;
}

.badge-purple {
  background: rgba(103, 58, 183, 0.1);
  color: #673AB7;
}

/* 响应式 */
@media (max-width: 1200px) {
  .content {
    grid-template-columns: 1fr;
    max-width: 800px;
  }

  .header {
    margin: 1rem;
  }

  .header h1 {
    font-size: 2rem;
  }
}

@media (max-width: 768px) {
  .content {
    padding: 0 1rem 1rem 1rem;
  }

  .header {
    padding: 1.5rem;
  }

  .back-btn {
    position: static;
    margin-bottom: 1rem;
  }

  .info-section {
    padding: 1.5rem;
  }
}
</style>
