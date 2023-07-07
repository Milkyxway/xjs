<template>
  <div>
    <form :v-model="queryForm">
      <el-row>
        <span>任务年度</span>
        <el-col :span="10"
          ><el-date-picker
            type="year"
            v-model="queryForm.year"
            placeholder="请选择"
          ></el-date-picker
        ></el-col>
        <span>任务类别</span>
        <el-col :span="10">
          <el-select v-model="queryForm.category" placeholder="请选择">
            <el-option
              v-for="item in taskCategoryList"
              v-bind:key="item.key"
              :value="item.value"
              :label="item.label"
              >{{ item.label }}</el-option
            >
          </el-select>
        </el-col>
      </el-row>
      <div class="white-space"></div>
      <el-row>
        <span>组织架构</span>
        <el-col :span="10"><el-time-picker placeholder="请选择"></el-time-picker></el-col>
        <span>任务状态</span>
        <el-col :span="10"
          ><el-select v-model="queryForm.status" placeholder="请选择">
            <el-option
              v-for="item in statusList"
              v-bind:key="item.key"
              :value="item.value"
              :label="item.label"
              >{{ item.label }}</el-option
            >
          </el-select></el-col
        >
      </el-row>
      <el-row>
        <el-col :span="2"><span>关键字</span></el-col>
        <el-col :span="8"
          ><el-input placeholder="请输入" v-model="queryForm.keyword"></el-input
        ></el-col>
      </el-row>
    </form>
    <div class="btn-wrap">
      <el-button @click="reset" plain>重置查询</el-button>
      <el-button @click="handleQuery" type="primary" plain>查询</el-button>
      <el-button @click="createTask" type="primary">新建任务</el-button>
    </div>
  </div>
</template>
<script setup>
import { ref, reactive } from 'vue'
import { taskStatusList, taskCategory } from '../constant'
const emit = defineEmits(['handleQuery', 'createTask'])
let queryForm = reactive({
  category: '',
  orgnization: '',
  status: '',
  keyword: '',
  year: ''
})
const statusList = ref(taskStatusList)
const taskCategoryList = ref(taskCategory)
const handleQuery = () => {
  emit('handleQuery', queryForm)
}
const createTask = () => {
  emit('createTask')
}
const reset = () => {
  queryForm.keyword = ''
  queryForm.category = ''
  queryForm.orgnization = ''
  queryForm.status = ''
  queryForm.year = ''
}
</script>
<style scoped>
.white-space {
  height: 10px;
}
.btn-wrap {
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
  align-items: center;
  padding: 15px 0;
}
</style>
