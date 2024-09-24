<template>
  <div class="chart-page">
    <div class="left-content">
      <div class="finish-container common-title">任务完成情况</div>
      <div class="sort-container common-title">部门完成情况排序</div>
      <div class="common-title">任务完成情况</div>
    </div>
    <div class="center-content"></div>
    <div class="right-content"></div>
  </div>
</template>
<style scoped>
.chart-page {
  width: 100%;
  height: 100vh;
  background: #0a1635;
  padding: 22px;
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
  align-items: flex-start;
  flex: 1;
}
.finish-container {
  width: 499px;
}
.sort-container {
  width: 100%;
  height: 503px;
  opacity: 1;
  background: #121f44;
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0px 0px 35px 0px rgba(0, 0, 0, 0.18), inset 0px 0px 99px 0px rgba(255, 255, 255, 0.17);
}
.common-title {
  font-family: 思源黑体;
  font-size: 24px;
  font-weight: 500;
  line-height: 35px;
  letter-spacing: 0px;
  color: #6ccee6;
  position: relative;
}
.common-title::before {
  width: 4px;
  height: 24px;
  opacity: 1;
  box-sizing: border-box;
  border: 4px dashed #6ccee6;
  position: absolute;
  left: 20px;
  top: 0;
}
</style>
