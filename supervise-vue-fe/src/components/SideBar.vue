<template>
  <el-menu default-active="2" class="el-menu-vertical-demo" @open="handleOpen" @close="handleClose">
    <el-sub-menu v-for="item in navConfig" :index="item.key">
      <template #title>
        <el-icon><location /></el-icon>
        <span>{{ item.name }}</span>
      </template>
      <el-menu-item-group v-for="child in item.children">
        <el-menu-item :index="`${item.key}-${child.key}`">{{
          child.name
        }}</el-menu-item></el-menu-item-group
      >
    </el-sub-menu>
  </el-menu>
</template>
<script>
import { reactive, ref, toRefs } from 'vue'
export default {
  setup() {
    const state = reactive({
      navConfig: [
        {
          name: '督办模块',
          url: '/supervise',
          children: [
            // {
            //   name: '上传任务',
            //   url: '/upload'
            // },
            {
              name: '任务列表',
              url: '/list'
            }
          ]
        }
      ]
    })
    const handleOpen = () => {}
    const handleClose = () => {}
    return {
      ...toRefs(state),
      handleClose,
      handleOpen
    }
  }
}
</script>
<style></style>
