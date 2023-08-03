import { createRouter, createWebHashHistory } from 'vue-router'
export const routeList = [
  {
    path: '/login',
    name: 'login',
    alias: '/',
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
            path: '/supervise/charts',
            name: '任务报表',
            isSider: true,
            component: () => import('../views/charts.vue')
          },
          {
            path: '/supervise/detail/:taskId',
            name: '任务详情',
            component: () => import('../views/detail.vue')
          }
        ]
      },
      {
        name: '账号模块',
        path: '/personal',
        component: () => import('../views/PersonalHome.vue'),
        children: [
          {
            path: '/personal/password',
            name: '修改密码',
            isSider: true,
            component: () => import('../views/password.vue')
          },
          {
            path: '/personal/createaccount',
            name: '创建账号',
            isSider: true,
            auth: ['admin'],
            component: () => import('../views/createaccount.vue')
          }
        ]
      }
    ]
  }
]
const router = createRouter({
  history: createWebHashHistory(import.meta.env.BASE_URL),
  routes: routeList
})

export default router
