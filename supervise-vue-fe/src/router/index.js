import { createRouter, createWebHashHistory } from 'vue-router'
export const routeList = [
  {
    path: '/login',
    name: 'login',
    cnName: '登录',
    alias: '/',
    component: () => import('../views/login.vue')
  },
  // {
  //   path: '/loginwifi',
  //   name: 'loginwifi',
  //   cnName: '登录',
  //   alias: '/',
  //   component: () => import('../views/loginwifi.vue')
  // },
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
            name: 'list',
            cnName: '任务列表',
            isSider: true,
            component: () => import('../views/list.vue'),
            meta: {
              keepAlive: true
            }
          },
          {
            path: '/supervise/charts',
            name: 'charts',
            cnName: '任务报表',
            isSider: true,
            auth: ['admin', 'section', 'leader', 'sub-leader'],
            component: () => import('../views/charts.vue')
          },
          {
            path: '/supervise/detail/:taskId',
            name: 'detail',
            cnName: '任务详情',
            component: () => import('../views/detail.vue')
          }
        ]
      },
      // {
      //   path: '/report',
      //   name: '报表模块',
      //   iconName: 'view',
      //   component: () => import('../views/SuperviseHome.vue'),
      //   children: [
      //     {
      //       path: '/report/list',
      //       name: '报表列表',
      //       isSider: true,
      //       component: () => import('../views/reportlist.vue')
      //     }
      //   ]
      // },
      {
        name: '账号模块',
        path: '/personal',
        component: () => import('../views/PersonalHome.vue'),
        children: [
          {
            path: '/personal/password',
            name: 'password',
            cnName: '修改密码',
            isSider: true,
            component: () => import('../views/password.vue')
          },
          {
            path: '/personal/createaccount',
            name: 'createaccount',
            cnName: '创建账号',
            isSider: true,
            auth: ['admin'],
            component: () => import('../views/createaccount.vue')
          },
          {
            path: '/personal/manageuser',
            name: 'manageuser',
            cnName: '用户管理',
            isSider: true,
            auth: ['admin'],
            component: () => import('../views/manageuser.vue')
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
