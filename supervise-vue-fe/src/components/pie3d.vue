<template>
  <highcharts :options="chartOptions" />
</template>
<script setup>
import { onMounted, onBeforeUnmount, ref } from 'vue'
const props = defineProps({
  data: {
    type: Array
  },
  total: {
    type: Number
  }
})

const getScale = () => {
  const viewWidth =
    window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth
  const viewHeight =
    window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight
  if (viewWidth <= 1500 || viewWidth / viewHeight <= 1.8) {
    return {
      width: 600,
      height: 300
    }
  }
  return {
    width: 1100,
    height: 500
  }
}
const chartOptions = ref({
  chart: {
    type: 'pie',
    options3d: {
      enabled: true,
      alpha: 45
    },
    backgroundColor: 'transparent',
    width: getScale().width,
    height: getScale().height
  },
  title: {
    text: '',
    align: 'left'
  },
  subtitle: {
    text: '',
    align: 'left'
  },
  plotOptions: {
    pie: {
      innerSize: 100,
      depth: 100,
      dataLabels: {
        enabled: true, //是否显示饼图的线形tip
        distance: 10, //设置引导线的长度 饼图的大小
        color: '#FFF', //全局设置字体颜色
        style: {
          textOutline: 'none', //去掉文字白边
          fontSize: '12'
        },
        // format: "{point.name}"
        formatter: function () {
          return (
            this.point.name + this.y + '个 占比' + ((this.y / props.total) * 100).toFixed(2) + '%'
          )
        }
      }
    }
  },
  series: [
    {
      name: '专项任务数量',
      data: props.data
    }
  ],
  colors: ['#E23AF5', '#7D4BFF', '#4164F3', '#94FFFF', '#4397FF', '#8BB6FF']
})
onMounted(() => {
  window.addEventListener('resize', (e) => {
    var width =
      window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth
    const scale = width / 2560
    chartOptions.value = {
      ...chartOptions.value,
      chart: {
        type: 'pie',
        options3d: {
          enabled: true,
          alpha: 45
        },
        backgroundColor: 'transparent',
        width: 1100 * scale,
        height: 500 * scale
      }
    }
  })
})
onBeforeUnmount(() => window.removeEventListener('resize'))
</script>
