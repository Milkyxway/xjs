<template>
  <highcharts :options="chartOptions" />
</template>
<script setup>
const props = defineProps({
  data: {
    type: Array
  },
  total: {
    type: Number
  }
})
const chartOptions = {
  chart: {
    renderTo: 'container',
    type: 'column',
    options3d: {
      enabled: true,
      alpha: 10,
      beta: 10,
      depth: 50,
      viewDistance: 20
    },
    backgroundColor: 'transparent',
    width: 400,
    height: 400,
    color: '#fff'
  },
  colorAxis: {
    gridLineColor: 'transparent'
  },
  labels: {
    style: {
      color: '#fff'
    }
  },
  xAxis: {
    type: '部门'
  },
  yAxis: {
    title: {
      enabled: false
    }
  },
  tooltip: {
    headerFormat: '<b>{point.key}</b><br>',
    pointFormat: '延期任务比例: {point.y}'
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
}
</script>
