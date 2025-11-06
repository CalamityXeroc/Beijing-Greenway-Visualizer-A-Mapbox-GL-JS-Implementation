import { createApp } from 'vue'
import router from './router'
import App from './App.vue'
import './assets/main.css'

const app = createApp(App)

app.use(router)

app.mount('#app')

console.log('🌳 北京绿道系统 Vue 应用已启动')
console.log('📍 基于 Vue 3 + OpenLayers + OLTB 架构')
