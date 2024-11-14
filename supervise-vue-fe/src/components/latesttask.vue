<template>
  <div class="rank rank-title">
    <span class="number">序号</span>
    <span class="content">任务概括</span>
    <span class="section">主办部门</span>
    <span class="time">创建时间</span>
  </div>
  <div v-for="(item, index) in props.data" v-bind:key="index" :class="getStyleByIndex(index)">
    <div class="number">{{ index + 1 }}</div>
    <div class="content">{{ item.taskContent }}</div>
    <div class="section">{{ item.leadOrg }}</div>
    <div class="time">{{ item.createTime }}</div>
  </div>
</template>
<script setup>
import { computed } from 'vue'
const props = defineProps({
  data: {
    type: Array
  }
})
const getStyleByIndex = computed(() => {
  return function (index) {
    let className = 'task-item'
    // if (index === 0) {
    //   className += ` light-purple`
    // } else if (index == 1) {
    //   className += ` dark-purple`
    // } else if (index == 2) {
    //   className += ` dark-ble`
    // }
    if (index % 2 === 0) {
      className += ` double-line`
    }
    return className
  }
})
</script>
<style scoped>
.rank {
  width: 100%;
  padding: 5px 10px;
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: flex-start;
  flex: 1;
}
.rank-grid {
  display: inline-block;
  width: 34%;
}
.rank-index {
  display: inline-block;
  width: 22%;
}
.rank-title {
  color: #6ccee6;
  margin-bottom: 5px;
}
.task-item {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  padding: 5px 10px;
}
.double-line {
  background-color: #11204a;
}
.number {
  width: 10%;
}
.content {
  width: 50%;
}

.section {
  width: 20%;
}
.time {
  width: 20%;
}
</style>
