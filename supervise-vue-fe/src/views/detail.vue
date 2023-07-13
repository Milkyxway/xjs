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
          <span class="bold space">任务类别: </span
          ><span>{{ state.taskDetail?.categoryName }}</span>
        </div>
        <div>
          <span class="bold space">任务内容: </span><span>{{ state.taskDetail.taskContent }}</span>
        </div>
        <div>
          <span class="bold space">责任部门: </span><span>{{ state.taskDetail.leadOrgName }}</span>
        </div>
        <div v-if="state.taskDetail.assistOrg !== ''">
          <span class="bold space">协办部门: </span
          ><span>{{ state.taskDetail.assistOrgName }}</span>
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
        <el-form-item label="是否拆分成阶段任务"
          ><el-switch v-model="state.hasChildTasks"></el-switch
        ></el-form-item>
        <el-form-item
          v-if="state.hasChildTasks"
          label="阶段任务1"
          :rules="[{ required: true, trigger: 'blur', message: '请完整填写' }]"
        >
          <div class="inline-wrap">
            <div><span>完成时间</span><el-date-picker></el-date-picker></div>
            <div>
              <span>完成目标</span><el-input></el-input
              ><el-icon color="#409eff" @click="addChild">
                <CirclePlus />
              </el-icon>
            </div>
          </div>
        </el-form-item>
        <el-form-item
          v-for="(item, index) in state.childTasks"
          :label="`阶段任务${index + 2}`"
          v-bind:key="index"
          :rules="[{ required: true, trigger: 'blur', message: '请完整填写' }]"
        >
          <div class="inline-wrap">
            <div><span>完成时间</span><el-date-picker></el-date-picker></div>
            <div>
              <span>完成目标</span><el-input></el-input>
              <el-icon @click="deleteChild(index)"><Delete /></el-icon>
            </div>
          </div>
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
      :formData="state.taskDetail"
    />
  </div>
</template>
<script setup>
import { reactive, computed } from 'vue'
import { useRoute } from 'vue-router'
import TaskModal from '../components/TaskModal.vue'
import { taskDetailReq, appealTaskReq } from '../api/list'
import { orgnizationListIdToName, orgnizationToName } from '../util/orgnization'
import { taskCategoryMap } from '../constant/index'
import { toast } from '../util/toast'
import dayjs from 'dayjs'
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
    categoryName: taskCategoryMap[category],
    leadOrgName: orgnizationToName(leadOrg),
    assistOrgName: orgnizationListIdToName(result.data.assistOrg)
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

const handleCommit = async (form) => {
  const { categoryName, leadOrgName, assistOrgName, createTime, ...rest } = form
  const result = await appealTaskReq({
    createTime: dayjs(createTime).format(),
    taskId,
    ...rest
  })
  state.modalVisible = false
  toast('申诉成功！')
  router.replace('/list')
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
.el-form-item {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: center;
}
.inline-wrap {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: center;
  white-space: nowrap;
}
</style>
