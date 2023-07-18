<template>
  <el-menu
    :default-active="currentSiderPath"
    class="el-menu-vertical-demo"
    @open="handleOpen"
    @close="handleClose"
    :router="true"
  >
    <el-sub-menu v-for="item in homeMenu" :key="item.path" :index="item.path">
      <template #title>
        <el-icon><location /></el-icon>
        <span>{{ item.name }}</span>
      </template>
      <el-menu-item-group
        v-for="child in item.children.filter((i) => i.isSider)"
        v-bind:key="child.key"
      >
        <el-menu-item :key="child.path" :index="child.path">{{
          child.name
        }}</el-menu-item></el-menu-item-group
      >
    </el-sub-menu>
  </el-menu>
</template>
<script setup>
import { reactive, computed } from 'vue'
import router, { routeList } from '../router/index'

const homeMenu = routeList.filter((item) => item.id === 'home')[0]?.children || []
let menuLevel = router.currentRoute.value.matched?.length || 0
let currentPath = router.currentRoute.value.fullPath
const currentSiderPath = computed(() => {
  let fullPath = router.currentRoute.value.fullPath
  let siderPath = fullPath.split('/')?.splice(0, 3)?.join('/')
  return siderPath
})
const defaultSelectedKey =
  currentPath === '/' || menuLevel < 3 ? '/dataCenter/project' : currentPath

const handleOpen = () => {}
const handleClose = () => {}
</script>
<style></style>
