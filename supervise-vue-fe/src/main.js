import './assets/main.css'
import 'element-plus/dist/index.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
// import './util/rem'
import App from './App.vue'
import router from './router'
// import mitt from 'mitt'

const app = createApp(App)
// app.config.globalProperties.$mitt = mitt()
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

app.use(createPinia())
app.use(router)

app.mount('#app')
app.directive('showByAuth', (el, binding) => {
  // 这会在 `mounted` 和 `updated` 时都调用
  const adminAuth = ['admin']
  const {
    value: { role, showCondition, otherCondition = true }
  } = binding
  el.style.display = showCondition.includes(role) && otherCondition ? 'inline' : 'none'
})
