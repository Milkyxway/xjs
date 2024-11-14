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

// provide(THEME_KEY, 'dark')
const props = defineProps({
  data: {
    type: Array
  },
  type: {
    type: String
  }
})
let option = ref()
watch()
const commonChart = () => {
  const { data, type } = props
  return (option.value = {
    tooltip: {
      formatter: '{a} <br/>{b} : {c}%'
    },
    series: [
      {
        type: 'gauge',
        center: ['50%', '70%'], //调整位置
        radius: 65, //外圆半径55
        startAngle: 180,
        endAngle: 0, // 结束位置
        pointer: {
          show: false // 是否显示仪表盘指针
        },
        progress: {
          // 展示当前进度。
          show: true, // 是否展示进度条
          overlap: false, // 是否重叠
          roundCap: false, // 是否圆顶
          clip: false // 是否裁掉超出部分
        },
        axisLine: {
          // 设置线条
          lineStyle: {
            width: 15, // 圆环宽 15
            opacity: 0.1
          }
        },
        itemStyle: {
          normal: {
            //具体颜色显示
            color: {
              type: 'radial', // 使用径向渐变色
              x: 0.2, // 渐变色的起始点位置
              y: 1,
              r: 1, // 渐变半径，值为0到1之间
              colorStops: [
                { offset: 0, color: '#94ffff' }, // 渐变颜色1
                { offset: 1, color: '#4397ff' } // 渐变颜色2
              ]
            },
            borderRadius: 5,
            //饼状图阴影，值越大阴影亮度越高
            shadowBlur: 24 // 模糊
            // shadowColor: 'rgba(0, 255, 229, 0.5)' ,// 圆环阴影色
          }
        },
        splitLine: {
          // 分隔线样式。
          show: false, // 是否显示分隔线。
          distance: 0, // 分隔线与轴线的距离。
          length: 1033 // 分隔线线长。支持相对半径的百分比。
        },
        axisTick: {
          // 刻度样式。
          show: false // 是否显示刻度。
        },
        axisLabel: {
          //刻度标签。
          show: false, // 是否显示标签。
          distance: 50 // 标签与刻度线的距离。
        },
        data: [
          {
            value: props.data, // 可写变量  此value 对应 formatter: '{value}%' 中的Value
            detail: {
              // 仪表盘边框数据详情，用于显示数据。
              valueAnimation: true, // 是否开启标签的数字动画。
              offsetCenter: ['0%', '-15%'], // 相对于仪表盘中心的偏移位置，数组第一项是水平方向的偏移，第二项是垂直方向的偏移。可以是绝对的数值，也可以是相对于仪表盘半径的百分比。
              fontSize: 16 // 文字的字体大小。
            }
          }
        ],
        detail: {
          //仪表盘详情，用于显示数据 仪表盘中间数字数据。
          color: `#fff`, // 文本颜色，默认取数值所在的区间的颜色
          formatter: `{value}%` // 格式化函数或者字符串
        }
      }
    ]
  })
}
option.value = commonChart()
</script>

<style scoped>
.chart {
  /* height: 100vh; */
  height: 80px;
}
</style>
