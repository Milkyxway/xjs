<template>
  <div>
    <el-row>
      <el-col :span="4"><span>任务年度</span></el-col>
      <el-col :span="8"><el-time-picker></el-time-picker></el-col>
      <el-col :span="4"><span>任务类别</span></el-col>
      <el-col :span="8"><el-select></el-select></el-col>
    </el-row>
    <el-row>
      <el-col :span="4"><span>组织架构</span></el-col>
      <el-col :span="8"><el-time-picker></el-time-picker></el-col>
      <el-col :span="4"><span>任务状态</span></el-col>
      <el-col :span="8"><el-select></el-select></el-col>
    </el-row>
    <el-button @click="handleQuery">查询</el-button>
    <el-button @click="createTask">新建任务</el-button>
  </div>
</template>
<script>
export default {
  setup(props, { emit }) {
    const handleQuery = () => {
      emit('handleQuery')
    }
    const createTask = () => {
      emit('createTask')
    }
    return {
      handleQuery,
      createTask
    }
  }
}
</script>
<style></style>
