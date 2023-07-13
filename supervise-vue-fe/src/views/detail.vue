<template>
  <div>
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>任务详情</span>
          <div v-if="state.taskDetail.status === 1">
            <el-button @click="taskAppeal">任务申诉</el-button>
            <el-button type="primary" @click="confirmTask">任务确认</el-button>
          </div>
        </div>
      </template>
      <div class="card-content">
        <div>
          <span class="bold space">任务类别: </span><span>{{ state.taskDetail?.category }}</span>
        </div>
        <div>
          <span class="bold space">任务内容: </span><span>{{ state.taskDetail.taskContent }}</span>
        </div>
        <div>
          <span class="bold space">责任部门: </span><span>{{ state.taskDetail.leadOrg }}</span>
        </div>
        <div>
          <span class="bold space">协办部门: </span><span>{{ state.taskDetail.assistOrg }}</span>
        </div>
      </div>
    </el-card>

    <el-card v-if="state.showTaskGoal">
      <template #header>
        <div class="card-header">
          <span>填写任务计划</span>
          <div>
            <el-button type="primary" @click="confirmTask">提交</el-button>
          </div>
        </div>
      </template>
      <el-form>
        <el-form-item label="是否拆分子任务"
          ><el-switch v-model="state.hasChildTasks"></el-switch
        ></el-form-item>
        <el-form-item v-if="state.hasChildTasks" label="子任务1"
          ><el-date-picker></el-date-picker
          ><el-icon color="#409eff" @click="addChild"><CirclePlus /></el-icon
        ></el-form-item>
        <el-form-item
          v-for="(item, index) in state.childTasks"
          :label="`子任务${index + 2}`"
          v-bind:key="index"
        >
          <el-date-picker></el-date-picker><el-icon @click="deleteChild(index)"><Delete /></el-icon>
        </el-form-item>
        <el-form-item label="完成计划" v-if="!state.hasChildTasks">
          <el-date-picker></el-date-picker>
        </el-form-item>
      </el-form>
    </el-card>
    <TaskModal
      :modalVisible="state.modalVisible"
      modalType="appeal"
      @handleCancel="state.modalVisible = false"
      @handle-commit="handleCommit"
      :formData="taskDetail"
    />
  </div>
</template>
<script setup>
import { reactive, computed } from 'vue'
import { useRoute } from 'vue-router'
import TaskModal from '../components/TaskModal.vue'
import { taskDetailReq } from '../api/list'
import { orgnizationListIdToName, orgnizationToName } from '../util/orgnization'
import { taskCategoryMap } from '../constant/index'
const router = useRoute()
const taskId = router.params.taskId

// const getTaskCatefory = computed(() => {
//   return function (category) {
//     return taskCategoryMap[category]
//   }
// })
let state = reactive({
  modalVisible: false,
  taskDetail: {},
  showTaskGoal: false,
  hasChildTasks: false,
  childTasks: []
})

const getTaskDetail = async () => {
  const result = await taskDetailReq({ taskId })
  const {
    data: { category, leadOrg }
  } = result
  state.taskDetail = {
    ...result.data,
    category: taskCategoryMap[category],
    leadOrg: orgnizationToName(leadOrg),
    assistOrg: orgnizationListIdToName(result.data.assistOrg)
  }
}

const taskAppeal = () => {
  state.modalVisible = true
}
const confirmTask = () => {
  state.showTaskGoal = true
}

const addChild = () => {
  state.childTasks.push({})
}

const deleteChild = (index) => {
  state.childTasks.splice(index, 1)
}

getTaskDetail()
</script>
<style scoped>
.card-content {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
}
.card-header {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
}
.bold {
  font-weight: bold;
}
.space {
  padding-right: 20px;
}
</style>
