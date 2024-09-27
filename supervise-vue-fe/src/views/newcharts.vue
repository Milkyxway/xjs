<template>
  <div class="chart-page" v-if="state.init">
    <div class="left-content">
      <div class="common-container left-top">
        <div class="common-title">任务完成情况</div>
        <div class="grid">
          <div>{{ state.totalTask || 123 }}</div>
        </div>
      </div>
      <WhiteSpace></WhiteSpace>
      <div class="common-container">
        <div class="common-title">部门完成情况排序</div>
        <BarCharts :data="state.sectionTask" :legend="state.sectionTaskLegend" />
      </div>
    </div>
    <div class="center-content">
      <div class="title">无锡专项任务督办平台驾驶舱</div>
      <white-space></white-space>
      <div class="center-top">
        <div class="common-title">任务状态占比</div>
      </div>
      <white-space></white-space>
      <div class="common-container">
        <div class="common-title">月度新增任务</div>
      </div>
    </div>
    <div class="right-content">
      <div class="common-container left-top">
        <div class="common-title">任务类别占比</div>
      </div>
      <white-space></white-space>
      <div class="common-container left-top">
        <div class="common-title">任务延期情况</div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { reactive, ref } from 'vue'
import { storeToRefs } from 'pinia'
import { sectionStore } from '../stores/orgList'
import WhiteSpace from '../components/WhiteSpace.vue'
import { getSectionTaskSortReq, getFinishRateReq } from '../api/charts'
import BarCharts from '../components/BarCharts.vue'
import { getLocalStore } from '../util/localStorage'
import { orgnizationToName } from '../util/orgnization'
const state = reactive({
  init: false,
  totalTask: 0,
  finishProcess: 0,
  sectionTask: [],
  sectionTaskLegend: []
})
const region = ref(getLocalStore('userInfo').region)
const setionStore = sectionStore()
const { sectionList } = storeToRefs(setionStore)

const getData = async () => {
  await setionStore.getOrgList()
  const sectionTask = await getSectionTaskSortReq({ region: region.value })
  const sectionFinishRate = await getFinishRateReq({ region: region.value })
  state.sectionTask = sectionTask.data.map((i) => i.value)
  state.sectionTaskLegend = sectionTask.data.map((i) =>
    orgnizationToName(i.name, sectionList.value)
  )
  state.init = true
}
getData()
</script>
<style scoped>
.chart-page {
  width: 100%;
  height: 100vh;
  background: #0a1635;
  padding: 22px;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: flex-start;
  flex: 1;
}
.common-border {
  background: #14234b;
  border: 2px rgba(255, 255, 255, 0.3);
  box-shadow: 0px 0px 35px 0px rgba(0, 0, 0, 0.18), inset 0px 0px 99px 0px rgba(255, 255, 255, 0.17);
}
.left-content {
  width: 26%;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
  flex: 1;
  margin: 0 30px 0 0;
}
.center-content {
  width: 700px;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  flex: 1;
}

.common-container {
  padding: 20px 0;
  box-sizing: border-box;
  width: 100%;
  height: auto;
  opacity: 1;
  background: #121f44;
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0px 0px 35px 0px rgba(0, 0, 0, 0.18), inset 0px 0px 99px 0px rgba(255, 255, 255, 0.17);
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.common-title {
  margin: 0 0 0 20px;
  font-family: 思源黑体;
  font-size: 16px;
  font-weight: 500;
  line-height: 35px;
  letter-spacing: 0px;
  color: #6ccee6;
  position: relative;
  /* 设置字体透明 */
  color: transparent;
  /* 设置线性渐变，从红色渐变到蓝色 */
  background-image: linear-gradient(0deg, #94ffff, #4397ff);
  /* 使用 -webkit-background-clip 属性将背景剪裁至文本形状 */
  -webkit-background-clip: text;
  /* 非Webkit内核浏览器需要使用标准前缀 */
  background-clip: text;
  /* 把当前元素设置为行内块，以便能够应用背景 */
  display: inline-block;
}
.common-title::before {
  content: '';
  width: 4px;
  height: 20px;
  border-radius: 3px;
  opacity: 1;
  background: #6ccee6;
  box-sizing: border-box;
  position: absolute;
  left: -10px;
  top: 8px;
}

.grid {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: row;
  align-items: flex-start;
}

.right-content {
  width: 26%;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
  flex: 1;
  margin: 0 0 0 30px;
}
.title {
  width: 700px;
  text-align: center;
  font-size: 30px;
  color: #fff;
}
.center-top {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
  width: 100%;
  margin-left: 65px;
}
</style>
