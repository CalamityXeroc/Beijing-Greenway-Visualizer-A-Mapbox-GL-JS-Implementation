<template>
  <div class="weather-card">
    <div class="weather-header">
      <i class="fas fa-cloud-sun weather-icon"></i>
      <h3 class="weather-title">实时天气信息</h3>
      <button @click="refresh" class="refresh-btn" :disabled="loading" :class="{ spinning: loading }">
        <i class="fas fa-sync-alt"></i>
      </button>
    </div>

    <div v-if="loading" class="loading">
      <i class="fas fa-spinner fa-spin"></i> 正在加载天气数据...
    </div>

    <div v-else-if="error" class="error">
      <i class="fas fa-exclamation-triangle"></i>
      <p>{{ error }}</p>
      <button @click="refresh" class="retry-btn">重试</button>
    </div>

    <div v-else-if="weather" class="weather-content">
      <div class="weather-item">
        <div class="weather-item-icon">
          <i :class="`fas ${getWeatherIcon(weather.weather)}`" style="color: #FF9800;"></i>
        </div>
        <div class="weather-item-value">{{ weather.weather }}</div>
        <div class="weather-item-label">天气状况</div>
      </div>

      <div class="weather-item">
        <div class="weather-item-icon">
          <i class="fas fa-temperature-high" style="color: #F44336;"></i>
        </div>
        <div class="weather-item-value">{{ weather.temperature }}°C</div>
        <div class="weather-item-label">实时气温</div>
      </div>

      <div class="weather-item">
        <div class="weather-item-icon">
          <i class="fas fa-wind" style="color: #2196F3;"></i>
        </div>
        <div class="weather-item-value">{{ weather.winddirection }}风</div>
        <div class="weather-item-label">{{ weather.windpower }}级</div>
      </div>

      <div class="weather-item">
        <div class="weather-item-icon">
          <i class="fas fa-tint" style="color: #00BCD4;"></i>
        </div>
        <div class="weather-item-value">{{ weather.humidity }}%</div>
        <div class="weather-item-label">空气湿度</div>
      </div>

      <div class="weather-item">
        <div class="weather-item-icon">
          <i class="fas fa-clock" style="color: #9C27B0;"></i>
        </div>
        <div class="weather-item-value">{{ formatTime(weather.reporttime) }}</div>
        <div class="weather-item-label">更新时间</div>
      </div>

      <div class="weather-item">
        <div class="weather-item-icon">
          <i class="fas fa-map-marker-alt" style="color: #4CAF50;"></i>
        </div>
        <div class="weather-item-value">{{ weather.city || '北京' }}</div>
        <div class="weather-item-label">所在城市</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, computed } from 'vue'

const props = defineProps({
  longitude: {
    type: Number,
    required: true
  },
  latitude: {
    type: Number,
    required: true
  },
  apiKey: {
    type: String,
    default: 'd9dd334682ca1fc6537ffaaccf795fbd'
  },
  autoRefresh: {
    type: Boolean,
    default: true
  },
  refreshInterval: {
    type: Number,
    default: 30 * 60 * 1000 // 30分钟
  }
})

const emit = defineEmits(['weather-loaded', 'weather-error'])

const weather = ref(null)
const loading = ref(false)
const error = ref(null)
let refreshTimer = null

// 天气图标映射
const weatherIcons = {
  '晴': 'fa-sun',
  '多云': 'fa-cloud-sun',
  '阴': 'fa-cloud',
  '雨': 'fa-cloud-rain',
  '雪': 'fa-snowflake',
  '雷阵雨': 'fa-cloud-bolt',
  '雾': 'fa-smog',
  '霾': 'fa-smog'
}

const getWeatherIcon = (weatherText) => {
  return weatherIcons[weatherText] || 'fa-cloud'
}

const formatTime = (timeStr) => {
  if (!timeStr) return '--'
  const parts = timeStr.split(' ')
  return parts.length > 1 ? parts[1] : timeStr
}

// 获取天气数据
const fetchWeather = async () => {
  loading.value = true
  error.value = null

  try {
    // 1. 逆地理编码获取城市代码
    const geoResponse = await fetch(
      `https://restapi.amap.com/v3/geocode/regeo?key=${props.apiKey}&location=${props.longitude},${props.latitude}`
    )
    const geoData = await geoResponse.json()

    if (geoData.status !== '1' || !geoData.regeocode) {
      throw new Error('位置解析失败')
    }

    const adcode = geoData.regeocode.addressComponent.adcode
    let cityName = geoData.regeocode.addressComponent.city || 
                   geoData.regeocode.addressComponent.province
    
    // 修复：如果 cityName 是数组，取第一个元素
    if (Array.isArray(cityName)) {
      cityName = cityName[0] || '未知城市'
    }
    // 如果是空数组或空字符串，使用省份名称
    if (!cityName || cityName.length === 0) {
      cityName = geoData.regeocode.addressComponent.province || '北京市'
    }

    // 2. 获取天气数据
    const weatherResponse = await fetch(
      `https://restapi.amap.com/v3/weather/weatherInfo?key=${props.apiKey}&city=${adcode}&extensions=base`
    )
    const weatherData = await weatherResponse.json()

    if (weatherData.status !== '1' || !weatherData.lives || weatherData.lives.length === 0) {
      throw new Error('天气数据获取失败')
    }

    weather.value = {
      ...weatherData.lives[0],
      city: cityName
    }

    emit('weather-loaded', weather.value)
    console.log('[WeatherCard] 天气数据加载成功:', weather.value)
  } catch (err) {
    error.value = err.message || '天气数据加载失败'
    emit('weather-error', err)
    console.error('[WeatherCard] 天气数据加载失败:', err)
  } finally {
    loading.value = false
  }
}

// 刷新天气
const refresh = () => {
  fetchWeather()
}

// 启动自动刷新
const startAutoRefresh = () => {
  if (props.autoRefresh && !refreshTimer) {
    refreshTimer = setInterval(() => {
      console.log('[WeatherCard] 自动刷新天气数据...')
      fetchWeather()
    }, props.refreshInterval)
  }
}

// 停止自动刷新
const stopAutoRefresh = () => {
  if (refreshTimer) {
    clearInterval(refreshTimer)
    refreshTimer = null
  }
}

onMounted(() => {
  fetchWeather()
  startAutoRefresh()
})

onBeforeUnmount(() => {
  stopAutoRefresh()
})

// 暴露方法
defineExpose({
  refresh,
  getWeather: () => weather.value
})
</script>

<style scoped>
.weather-card {
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  padding: 1.5rem;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  margin-top: 1rem;
}

.weather-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 1rem;
  padding-bottom: 1rem;
  border-bottom: 2px solid rgba(33, 150, 243, 0.1);
}

.weather-icon {
  font-size: 2rem;
  color: #2196F3;
}

.weather-title {
  font-size: 1.2rem;
  font-weight: 600;
  color: #2c3e50;
  margin: 0;
  flex: 1;
}

.refresh-btn {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1.2rem;
  color: #2196F3;
  padding: 0.5rem;
  border-radius: 50%;
  transition: all 0.3s ease;
}

.refresh-btn:hover:not(:disabled) {
  background: rgba(33, 150, 243, 0.1);
  transform: rotate(180deg);
}

.refresh-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.spinning i {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.loading,
.error {
  text-align: center;
  padding: 2rem;
  color: #999;
}

.error {
  color: #f44336;
}

.error i {
  font-size: 2rem;
  margin-bottom: 1rem;
  display: block;
}

.error p {
  margin: 0 0 1rem 0;
  font-size: 1rem;
}

.retry-btn {
  padding: 0.5rem 1rem;
  background: #2196F3;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: background 0.2s;
}

.retry-btn:hover {
  background: #1976D2;
}

.weather-content {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1rem;
}

.weather-item {
  text-align: center;
  padding: 1rem;
  background: rgba(33, 150, 243, 0.05);
  border-radius: 12px;
  transition: transform 0.2s ease;
}

.weather-item:hover {
  transform: translateY(-3px);
  background: rgba(33, 150, 243, 0.1);
}

.weather-item-icon {
  font-size: 1.8rem;
  margin-bottom: 0.5rem;
}

.weather-item-value {
  font-size: 1.5rem;
  font-weight: 700;
  color: #2196F3;
  margin-bottom: 0.25rem;
}

.weather-item-label {
  font-size: 0.85rem;
  color: #666;
}

/* 响应式 */
@media (max-width: 768px) {
  .weather-content {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 480px) {
  .weather-content {
    grid-template-columns: 1fr;
  }
}
</style>
