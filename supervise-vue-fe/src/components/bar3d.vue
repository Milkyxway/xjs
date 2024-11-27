<template>  <highcharts :options="chartOptions" /></template>
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

  if (viewWidth / viewHeight >= 1.97) {
    return {
      width: 300,
      height: 240
    }
  } else if (viewWidth <= 1500) {
    return {
      width: 300,
      height: 280
    }
  } else
    return {
      width: 500,
      height: 450
    }
}
const chartOptions = ref({
  chart: {
    renderTo: 'container',
    type: 'column',
    options3d: {
      enabled: true,
      alpha: 0,
      beta: 15,
      depth: 50
      // viewDistance: 15
    },
    width: getScale().width,
    height: getScale().height,
    backgroundColor: 'transparent'
  },
  colorAxis: {},
  xAxis: {
    type: 'category',
    className: 'x-axis'
  },
  yAxis: {
    title: {
      enabled: false
    },
    className: 'x-axis'
  },
  tooltip: {
    headerFormat: '<b>{point.key}</b><br>',
    pointFormat: '延期任务占比: {point.y}'
  },
  title: {
    text: '',
    align: 'left'
  },
  subtitle: {
    text: '',
    align: 'left'
  },
  legend: {
    enabled: false
  },
  plotOptions: {
    column: {
      depth: 25
    }
  },
  colors: ['#E23AF5', '#7D4BFF', '#4164F3', '#94FFFF', '#4397FF', '#8BB6FF'],
  series: [
    {
      data: props.data,
      colorByPoint: true
    }
  ]
})
onMounted(() => {
  window.addEventListener('resize', (e) => {
    var width =
      window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth
    const scale = width / 2560
    chartOptions.value = {
      ...chartOptions.value,
      chart: {
        renderTo: 'container',
        type: 'column',
        options3d: {
          enabled: true,
          alpha: 0,
          beta: 15,
          depth: 50
          // viewDistance: 15
        },
        width: 500 * scale,
        height: 480 * scale,
        backgroundColor: 'transparent'
      }
    }
  })
})
onBeforeUnmount(() => window.removeEventListener('resize'))
</script>
<style>
.x-axis {
  text {
    color: #fff !important;
    fill: #fff !important;
  }
}
</style>
