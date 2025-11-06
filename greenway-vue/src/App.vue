<template>
  <router-view v-slot="{ Component }">
    <transition name="fade" mode="out-in">
      <component :is="Component" />
    </transition>
  </router-view>
</template>

<script setup>
import { onMounted } from 'vue'

onMounted(() => {
  console.log('[App] 绿道系统 Vue 应用已启动')
})
</script>

<style>
/* App.vue 的样式已经在 main.css 中定义 */
</style>
