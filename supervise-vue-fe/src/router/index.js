import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/login',
      name: 'login',
      component: () => import('../views/login.vue')
    },

    {
      path: '/',
      name: 'home',
      component: () => import('../views/home.vue'),
      children: [
        {
          path: '/list',
          name: 'list',
          component: () => import('../views/list.vue')
        },
        {
          path: '/auth',
          name: 'auth'
        },
        {
          path: '/detail/:taskId',
          name: 'detail',
          component: () => import('../views/detail.vue')
        },
        {
          path: '/password',
          name: 'password',
          component: () => import('../views/password.vue')
        }
      ]
    }
  ]
})

export default router
