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
    type: 'pie',
    options3d: {
      enabled: true,
      alpha: 45
    },
    backgroundColor: 'transparent',
    width: 900,
    height: 400
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
      depth: 60,
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
}
</script>
