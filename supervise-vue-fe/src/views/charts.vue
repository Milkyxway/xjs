<template>
  <el-row v-if="state.init">
    <el-col :span="12"
      ><PieCharts
        :data="state.categoryPieData"
        :legend="state.categoryLegend"
        name="专项任务类别占比"
    /></el-col>
    <el-col :span="12">
      <PieCharts :data="state.statusPieData" :legend="state.statusLegend" name="专项任务状态占比" />
    </el-col>
  </el-row>
  <el-row v-if="state.init">
    <el-col :span="12">
      <BarCharts
        :data="state.sectionTask"
        name="各部门任务完成排序"
        :legend="state.sectionTaskLegend"
      />
    </el-col>
    <el-col :span="12">
      <GaugeChart :data="state.finishProcess" />
    </el-col>
  </el-row>
</template>
<script setup>
import { reactive, ref } from 'vue'
import { storeToRefs } from 'pinia'
import { sectionStore } from '../stores/orgList'
import PieCharts from '../components/PieCharts.vue'
import BarCharts from '../components/BarCharts.vue'
import GaugeChart from '../components/GaugeChart.vue'
import { getPieChartReq, getSectionTaskSortReq, getFinishProcessReq } from '../api/charts'
import {
  taskCategory,
  taskStatusList,
  taskCategoryMap,
  taskStatusMap,
  orgnizationTree
} from '../constant/index'
import { orgnizationToName } from '../util/orgnization'
import { getLocalStore } from '../util/localStorage'
const region = ref(getLocalStore('userInfo').region)
const state = reactive({
  categoryPieData: [],
  statusPieData: [],
  categoryLegend: taskCategory.map((i) => i.label),
  statusLegend: taskStatusList.map((i) => i.label),
  sectionTask: [],
  sectionTaskLegend: [],
  finishProcess: 0,
  init: false
})
const setionStore = sectionStore()
const { sectionList } = storeToRefs(setionStore)

const formatData = (data, map) => {
  return data.map((i) => {
    return { name: map[i.name], value: i.value }
  })
}

const getPieChart = async () => {
  await setionStore.getOrgList()
  const categoryPieData = await getPieChartReq({ type: 'category', region: region.value })
  const statusPieData = await getPieChartReq({ type: 'status', region: region.value })
  const sectionTask = await getSectionTaskSortReq({ region: region.value })
  const finishProcess = await getFinishProcessReq({ status: 4, region: region.value })
  state.categoryPieData = formatData(categoryPieData.data, taskCategoryMap)
  state.statusPieData = formatData(statusPieData.data, taskStatusMap)
  state.sectionTask = sectionTask.data.map((i) => i.value)
  state.sectionTaskLegend = sectionTask.data.map((i) =>
    orgnizationToName(i.name, sectionList.value)
  )
  state.finishProcess = ((finishProcess.data.statusTotal / finishProcess.data.total) * 100).toFixed(
    0
  )
  state.init = true
}
getPieChart()
</script>
