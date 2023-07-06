<template>
  <div>
    <el-row>
      <span>任务年度</span>
      <el-col :span="10"><el-time-picker></el-time-picker></el-col>
      <span>任务类别</span>
      <el-col :span="10"><el-select></el-select></el-col>
    </el-row>
    <el-row>
      <span>组织架构</span>
      <el-col :span="10"><el-time-picker></el-time-picker></el-col>
      <span>任务状态</span>
      <el-col :span="10"
        ><el-select>
          <el-option v-for="item in statusList" v-bind:key="item.key" :value="item.value">{{
            item.label
          }}</el-option>
        </el-select></el-col
      >
    </el-row>
    <div class="btn-wrap">
      <el-button @click="handleQuery">查询</el-button>
      <el-button @click="createTask" type="primary">新建任务</el-button>
    </div>
  </div>
</template>
<script>
import { ref } from 'vue'
import { taskStatusList } from '../constant'
export default {
  setup(props, { emit }) {
    const statusList = ref(taskStatusList)
    const handleQuery = () => {
      emit('handleQuery')
    }
    const createTask = () => {
      emit('createTask')
    }
    return {
      statusList,
      handleQuery,
      createTask
    }
  }
}
</script>
<style scoped>
.btn-wrap {
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
  align-items: center;
  padding: 15px 0;
}
</style>
