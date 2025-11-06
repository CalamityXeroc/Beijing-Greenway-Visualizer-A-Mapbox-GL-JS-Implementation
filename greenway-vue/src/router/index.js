import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/GreenwayOverview.vue'),
    meta: { title: '北京绿道系统总览' }
  },
  {
    path: '/wenyu',
    name: 'WenyuDetail',
    component: () => import('@/views/WenyuDetail.vue'),
    meta: { title: '温榆河绿道详情' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫 - 更新页面标题
router.beforeEach((to, from, next) => {
  document.title = to.meta.title || '北京绿道系统'
  next()
})

export default router
