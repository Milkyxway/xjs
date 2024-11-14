<template>
  <v-chart class="chart" :option="option" autoresize />
</template>

<script setup>
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { PieChart } from 'echarts/charts'
import { TitleComponent, TooltipComponent, LegendComponent } from 'echarts/components'
import VChart, { THEME_KEY } from 'vue-echarts'
import { ref, provide, reactive, watch } from 'vue'

use([CanvasRenderer, PieChart, TitleComponent, TooltipComponent, LegendComponent])

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
const commonChart = () => {
  const { data, legend, name } = props
  return {
    tooltip: {
      trigger: 'item',
      formatter: '{a} <br/>{b} : {c} ({d}%)'
    },
    // legend: {
    //   left: 'center',
    //   top: 'bottom',
    //   data: data.map((i) => i.name)
    // },
    toolbox: {
      show: true,
      feature: {
        mark: { show: true },
        dataView: { show: true, readOnly: false },
        restore: { show: true },
        saveAsImage: { show: true }
      }
    },
    color: ['#E23AF5', '#7D4BFF', '#4164F3', '#94FFFF', '#4397FF', '#8BB6FF'],
    series: [
      {
        name: '专项任务类别占比',
        type: 'pie',
        radius: [30, 100],
        center: ['50%', '50%'],
        roseType: 'area',
        itemStyle: {
          borderRadius: 20
        },
        data,
        itemStyle: {
          normal: {
            //具体颜色显示
            borderRadius: 5,
            //饼状图阴影，值越大阴影亮度越高
            shadowBlur: 70 // 模糊
            // shadowColor: 'rgba(0, 255, 229, 0.5)' // 圆环阴影色
          }
        }
      }
    ]
  }
}
option.value = commonChart()
</script>

<style scoped>
.chart {
  /* height: 100vh; */
  height: 240px;
}
</style>
