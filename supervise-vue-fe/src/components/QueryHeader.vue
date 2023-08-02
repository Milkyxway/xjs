<template>
  <el-card :class="[`card-${role}`]">
    <form :v-model="queryForm">
      <el-row>
        <el-col :span="styleByRole.spanSpace">任务类别</el-col>
        <el-col :span="styleByRole.elSpace">
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
        <el-col :span="styleByRole.spanSpace" v-if="['admin'].includes(role)">任务来源</el-col>
        <el-col :span="styleByRole.elSpace" v-if="['admin'].includes(role)">
          <el-select v-model="queryForm.taskSource" placeholder="请选择任务来源" clearable>
            <el-option
              v-for="item in taskOriginRef"
              v-bind:key="item.key"
              :value="item.value"
              :label="item.label"
              >{{ item.label }}</el-option
            >
          </el-select>
        </el-col>
        <el-col :span="styleByRole.spanSpace">牵头部门</el-col>
        <el-col :span="styleByRole.elSpace">
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
        <el-col :span="styleByRole.spanSpace">协办部门</el-col>
        <el-col :span="styleByRole.elSpace">
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
        <el-col :span="styleByRole.spanSpace" v-if="['admin'].includes(role)">提出部门</el-col>
        <el-col :span="styleByRole.elSpace" v-if="['admin'].includes(role)"
          ><el-select v-model="queryForm.ariseOrg" placeholder="请选择提出部门" clearable>
            <el-option
              v-for="item in orgnizationList"
              v-bind:key="item.key"
              :value="item.value"
              :label="item.label"
              >{{ item.label }}</el-option
            >
          </el-select></el-col
        >
        <el-col :span="styleByRole.spanSpace">任务状态</el-col>
        <el-col :span="styleByRole.elSpace"
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
        <el-col :span="styleByRole.spanSpace">任务年度</el-col>
        <el-col :span="styleByRole.elSpace"
          ><el-date-picker
            type="year"
            v-model="queryForm.createTime"
            placeholder="请选择任务年度"
            clearable
          ></el-date-picker
        ></el-col>
        <el-col :span="styleByRole.spanSpace">关键字</el-col>
        <el-col :span="styleByRole.elSpace"
          ><el-input placeholder="请输入关键字" v-model="queryForm.keyword" clearable></el-input
        ></el-col>
      </el-row>
    </form>
    <div class="btn-wrap">
      <el-button @click="reset" plain>重置查询</el-button>
      <el-button @click="handleQuery" type="primary">查询</el-button>
      <el-button @click="createTask" type="danger" v-showByAuth="{ role, showCondition: ['admin'] }"
        >新建任务</el-button
      >
    </div>
  </el-card>
</template>
<script setup>
import { ref, reactive, computed } from 'vue'
import { taskStatusList, taskCategory, orgnizationTree, taskOrigin } from '../constant'
import { getLocalStore } from '../util/localStorage'
const emit = defineEmits(['handleQuery', 'createTask'])
const role = getLocalStore('userInfo').role
let queryForm = reactive({
  category: null,
  status: null,
  keyword: '',
  createTime: null,
  leadOrg: null,
  assistOrg: null,
  taskSource: null,
  ariseOrg: null
})
const statusList = ref(taskStatusList)
const taskCategoryList = ref(taskCategory)
const orgnizationList = ref(orgnizationTree)
const taskOriginRef = ref(taskOrigin)
const styleByRole = computed(() => {
  return ['admin'].includes(role)
    ? {
        spanSpace: 2,
        elSpace: 4
      }
    : {
        spanSpace: 2,
        elSpace: 6
      }
})
const handleQuery = () => {
  emit('handleQuery', queryForm)
}
const createTask = () => {
  emit('createTask')
}
const reset = () => {
  Object.keys(queryForm).map((i) => {
    queryForm[i] = null
  })
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
.card-admin {
  :deep(.el-input) {
    width: 185px !important;
  }
}
.card-section {
  :deep(.el-input) {
    width: 280px !important;
  }
}
</style>
