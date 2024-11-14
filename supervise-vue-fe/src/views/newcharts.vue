<template>
  <div class="chart-page" v-if="state.init">
    <div class="left-content">
      <div class="common-container left-top">
        <div class="common-title">任务完成情况</div>
        <div class="grid">
          <div class="grid-item">
            <div>任务总数</div>
            <div class="total-amount">{{ state.statusRate.total }}</div>
          </div>
          <div class="grid-item">
            <div>任务完成率</div>
            <processchart :data="state.statusRate.finishRate" type="已完成" />
          </div>
          <!-- <div class="grid-item">
            <div>任务进行</div>
            <processchart :data="state.statusRate.processRate" type="进行中" />
          </div> -->
          <!-- <div class="grid-item">
            <div>任务延期</div>
            <processchart :data="state.statusRate.delayRate" type="已延期" />
          </div> -->
        </div>
      </div>
      <WhiteSpace></WhiteSpace>
      <div class="common-container">
        <div class="common-title">部门完成情况排序</div>
        <sectionrank :sectionTask="state.sectionTask" :sectionList="sectionList"></sectionrank>
      </div>
    </div>
    <div class="center-content">
      <div class="title">无锡专项任务督办平台驾驶舱</div>
      <white-space></white-space>
      <div class="center-top">
        <div class="common-title">任务状态占比</div>
        <statuspie :data="state.statusPieData" :legend="state.statusLegend" />
      </div>
      <white-space></white-space>
      <div class="common-container">
        <div class="common-title">月度新增任务</div>
        <latesttask :data="state.newInMonth" />
      </div>
    </div>
    <div class="right-content">
      <div class="common-container left-top">
        <div class="common-title">任务类别占比</div>
        <categorypie :data="state.categoryPieData" />
      </div>
      <white-space></white-space>
      <div class="common-container left-top">
        <div class="common-title">任务延期情况</div>
        <delayrank :data="state.delayTasks" :legend="state.delaySection" />
      </div>
    </div>
  </div>
</template>
<script setup>
import { reactive, ref, computed } from 'vue'
import { storeToRefs } from 'pinia'
import { sectionStore } from '../stores/orgList'
import WhiteSpace from '../components/WhiteSpace.vue'
import {
  getFinishRateReq,
  getStatusProportionReq,
  getNewTaskInMonthReq,
  getPieChartReq,
  getDelayTasksReq
} from '../api/charts'
import { taskStatusList, taskStatusMap, taskCategoryMap } from '../constant/index'
import { getLocalStore } from '../util/localStorage'
import { orgnizationToName } from '../util/orgnization'
import processchart from '../components/processchart.vue'
import statuspie from '../components/statuspie.vue'
import sectionrank from '../components/sectionrank.vue'
import delayrank from '../components/delayrank.vue'
import categorypie from '../components/categorypie.vue'
import latesttask from '../components/latesttask.vue'
import dayjs from 'dayjs'
const state = reactive({
  init: false,
  totalTask: 0,
  finishProcess: 0,
  statusRate: {
    finishRate: 0,
    processRate: 0,
    delayRate: 0,
    total: 0
  },
  statusPieData: [],
  statusLegend: [],
  sectionTask: [],
  sectionTaskLegend: [],
  statusLegend: taskStatusList.map((i) => i.label),
  categoryPieData: [],
  delayTasks: [],
  delaySection: [],
  newInMonth: []
})
const region = ref(getLocalStore('userInfo').region)
const setionStore = sectionStore()
const { sectionList } = storeToRefs(setionStore)

const formatProportionData = (data) => {
  const {
    data: { finishCount, delayCount, processCount, totalCount }
  } = data
  const finish = finishCount[0].value
  const total = totalCount[0].value
  const delay = delayCount[0].value
  const process = processCount[0].value
  state.statusRate.finishRate = ((finish / total).toFixed(2) * 100).toFixed(0)
  state.statusRate.processRate = ((process / total).toFixed(2) * 100).toFixed(0)
  state.statusRate.delayRate = ((delay / total).toFixed(2) * 100).toFixed(0)
  state.statusRate.total = total
}

const getData = async () => {
  await setionStore.getOrgList()
  const statusProportionRes = await getStatusProportionReq({ region: region.value })
  const sectionFinishRate = await getFinishRateReq({ region: region.value })
  const newInMonth = await getNewTaskInMonthReq({ region: region.value })
  const statusPieData = await getPieChartReq({ type: 'status', region: region.value })
  const categoryPieData = await getPieChartReq({ type: 'category', region: region.value })
  const delayTasks = await getDelayTasksReq({ region: region.value })
  formatProportionData(statusProportionRes)
  state.sectionTask = sectionFinishRate.data
  state.sectionTaskLegend = sectionFinishRate.data.map((i) =>
    orgnizationToName(i.leadOrg, sectionList.value)
  )
  state.newInMonth = formatTaskDetailData(newInMonth.data)
  state.statusPieData = formatData(statusPieData.data, taskStatusMap)

  state.categoryPieData = formatData(
    categoryPieData.data.filter((i) => i.name > 0),
    taskCategoryMap
  )
  state.categoryPieData.sort((a, b) => b.value - a.value)
  formDelayTasks(delayTasks.data, sectionFinishRate.data)
  state.init = true
}

const formDelayTasks = (delayTasks, sectionFinishRate) => {
  let data = []
  delayTasks.map((i) => {
    return sectionFinishRate.map((j) => {
      if (i.leadOrg === j.leadOrg) {
        data.push({
          ...i,
          total: j.total,
          rate: (i.count / j.total).toFixed(2)
        })
      }
    })
  })
  data.sort((a, b) => b.rate - a.rate)
  // state.delayTasks = data.slice(0, 5)
  state.delayTasks = data
  // state.delaySection = data.slice(0, 5).map((i) => orgnizationToName(i.leadOrg, sectionList.value))
  state.delaySection = data.map((i) => orgnizationToName(i.leadOrg, sectionList.value))
}

const formatData = (data, map) => {
  return data.map((i) => {
    return { name: map[i.name], value: i.value }
  })
}

const formatTaskDetailData = (data) => {
  return data.map((i) => {
    let loc
    const commaLoc = i.taskContent.indexOf('，')
    const fullstopLoc = i.taskContent.indexOf('。')
    if (commaLoc > -1 && fullstopLoc > -1) {
      loc = commaLoc > fullstopLoc ? fullstopLoc : commaLoc
    }
    if (commaLoc < 0 && fullstopLoc < 0) {
      loc = 20
    }
    if (commaLoc > -1 && fullstopLoc < 0) {
      loc = commaLoc
    }
    if (fullstopLoc > -1 && commaLoc < 0) {
      loc = fullstopLoc
    }
    return {
      ...i,
      taskContent: i.taskContent.substr(0, loc),
      leadOrg: orgnizationToName(i.leadOrg, sectionList.value),
      createTime: dayjs(i.createTime).format('YYYY-MM-DD')
    }
  })
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
  justify-content: flex-start;
  align-items: center;
}

.grid-item {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  width: 50%;
  height: 100px;
  font-size: 16px;
  color: #fff;
}
.total-amount {
  font-size: 32px;
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
