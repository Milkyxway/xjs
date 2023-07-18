import { createRouter, createWebHistory } from 'vue-router'
export const routeList = [
  {
    path: '/login',
    name: 'login',
    component: () => import('../views/login.vue')
  },

  {
    path: '/home',
    name: 'home',
    id: 'home',
    component: () => import('../views/home.vue'),
    children: [
      {
        path: '/supervise',
        name: '任务督办',
        iconName: 'view',
        component: () => import('../views/SuperviseHome.vue'),
        children: [
          {
            path: '/supervise/list',
            name: '任务列表',
            isSider: true,
            component: () => import('../views/list.vue')
          },
          {
            path: '/supervise/detail/:taskId',
            name: '任务详情',
            component: () => import('../views/detail.vue')
          }
        ]
      },
      {
        name: '个人中心',
        path: '/personal',
        component: () => import('../views/PersonalHome.vue'),
        children: [
          {
            path: '/personal/password',
            name: '修改密码',
            isSider: true,
            component: () => import('../views/password.vue')
          }
        ]
      }
    ]
  }
]
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: routeList
})

export default router
