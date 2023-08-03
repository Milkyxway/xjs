<template>
  <v-chart class="chart" :option="option" autoresize />
</template>

<script setup>
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { GaugeChart } from 'echarts/charts'
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
} from 'echarts/components'
import VChart, { THEME_KEY } from 'vue-echarts'
import { ref, provide, reactive, watch } from 'vue'

use([CanvasRenderer, TitleComponent, TooltipComponent, LegendComponent, GridComponent, GaugeChart])

provide(THEME_KEY, 'dark')
const props = defineProps({
  data: {
    type: Array
  },
  legend: {
    type: Array
  },
  name: {
    type: String
  }
})
let option = ref()
watch()
const commonChart = () => {
  const { data } = props
  console.log(data)
  return (option = {
    tooltip: {
      formatter: '{a} <br/>{b} : {c}%'
    },
    series: [
      {
        name: 'Pressure',
        type: 'gauge',
        detail: {
          formatter: '{value}'
        },
        data: [
          {
            value: data,
            name: '完成进度'
          }
        ]
      }
    ]
  })
}
option.value = commonChart()
</script>

<style scoped>
.chart {
  /* height: 100vh; */
  height: 300px;
}
</style>
