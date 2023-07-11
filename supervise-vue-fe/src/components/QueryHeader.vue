<template>
  <div>
    <form :v-model="queryForm">
      <el-row>
        <span>任务类别</span>
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
        <span>牵头部门</span>
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
        <span>协办部门</span>
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
        <span>任务状态</span>
        <el-col :span="6"
          ><el-select v-model="queryForm.status" placeholder="请选择" clearable>
            <el-option
              v-for="item in statusList"
              v-bind:key="item.key"
              :value="item.value"
              :label="item.label"
              >{{ item.label }}</el-option
            >
          </el-select></el-col
        >
        <span>任务年度</span>
        <el-col :span="6"
          ><el-date-picker
            type="year"
            v-model="queryForm.createTime"
            placeholder="请选择"
            clearable
          ></el-date-picker
        ></el-col>
        <el-col :span="2"><span>关键字</span></el-col>
        <el-col :span="6"
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
import { taskStatusList, taskCategory, orgnizationTree } from '../constant'
const emit = defineEmits(['handleQuery', 'createTask'])
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
:deep(.el-input__wrapper) {
  /* width: 250px; */
}
</style>
