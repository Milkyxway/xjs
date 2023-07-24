<template>
  <el-card>
    <form :v-model="queryForm">
      <el-row>
        <el-col :span="2">任务类别</el-col>
        <el-col :span="6">
          <el-select v-model="queryForm.category" placeholder="请选择任务类别" clearable>
            <el-option
              v-for="item in taskCategoryList"
              v-bind:key="item.key"
              :value="item.value"
              :label="item.label"
              >{{ item.label }}</el-option
            >
          </el-select>
        </el-col>
        <el-col :span="2">牵头部门</el-col>
        <el-col :span="6">
          <el-select placeholder="请选择牵头部门" v-model="queryForm.leadOrg" clearable>
            <el-option
              v-for="org in orgnizationList"
              v-bind:key="org.key"
              :label="org.label"
              :value="org.value"
              >{{ org.label }}</el-option
            >
          </el-select>
        </el-col>
        <el-col :span="2">协办部门</el-col>
        <el-col :span="6">
          <el-select placeholder="请选择协办部门" v-model="queryForm.assistOrg" clearable>
            <el-option
              v-for="org in orgnizationList"
              v-bind:key="org.key"
              :label="org.label"
              :value="org.value"
              >{{ org.label }}</el-option
            >
          </el-select>
        </el-col>
      </el-row>
      <div class="white-space"></div>
      <el-row>
        <el-col :span="2">任务状态</el-col>
        <el-col :span="6"
          ><el-select v-model="queryForm.status" placeholder="请选择任务状态" clearable>
            <el-option
              v-for="item in statusList"
              v-bind:key="item.key"
              :value="item.value"
              :label="item.label"
              >{{ item.label }}</el-option
            >
          </el-select></el-col
        >
        <el-col :span="2">任务年度</el-col>
        <el-col :span="6"
          ><el-date-picker
            type="year"
            v-model="queryForm.createTime"
            placeholder="请选择任务年度"
            clearable
          ></el-date-picker
        ></el-col>
        <el-col :span="2">关键字</el-col>
        <el-col :span="6"
          ><el-input placeholder="请输入关键字" v-model="queryForm.keyword" clearable></el-input
        ></el-col>
      </el-row>
    </form>
    <div class="btn-wrap">
      <el-button @click="reset" plain>重置查询</el-button>
      <el-button @click="handleQuery" type="primary">查询</el-button>
      <el-button @click="createTask" type="danger" v-showByAuth="{ role, showCondition: 'admin' }"
        >新建任务</el-button
      >
    </div>
  </el-card>
</template>
<script setup>
import { ref, reactive } from 'vue'
import { taskStatusList, taskCategory, orgnizationTree } from '../constant'
import { getLocalStore } from '../util/localStorage'
const emit = defineEmits(['handleQuery', 'createTask'])
const role = getLocalStore('userInfo').role
let queryForm = reactive({
  category: null,
  status: null,
  keyword: '',
  createTime: null,
  leadOrg: null,
  assistOrg: null
})
const statusList = ref(taskStatusList)
const taskCategoryList = ref(taskCategory)
const orgnizationList = ref(orgnizationTree)
const handleQuery = () => {
  emit('handleQuery', queryForm)
}
const createTask = () => {
  emit('createTask')
}
const reset = () => {
  queryForm.keyword = ''
  queryForm.category = null
  queryForm.leadOrg = null
  queryForm.assistOrg = null
  queryForm.status = null
  queryForm.createTime = null
  handleQuery()
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
  padding: 15px 0 0 0;
}
:deep(.el-input) {
  width: 250px !important;
}
</style>
