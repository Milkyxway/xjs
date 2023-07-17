<template>
  <div>
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span class="bold">任务详情</span>
          <div v-if="state.taskDetail.status === 1">
            <el-button @click="taskAppeal">任务调整</el-button>
            <el-button type="primary" @click="confirmTask">任务确认</el-button>
          </div>
        </div>
      </template>
      <div class="card-content">
        <div class="row-item">
          <div class="bold space">任务类别:</div>
          <div>{{ state.taskDetail?.categoryName }}</div>
        </div>
        <div class="row-item">
          <div class="bold space">任务内容:</div>
          <div class="content">{{ state.taskDetail.taskContent }}</div>
        </div>
        <div class="row-item">
          <div class="bold space">责任部门:</div>
          <div>{{ state.taskDetail.leadOrgName }}</div>
        </div>
        <div v-if="state.taskDetail.assistOrg !== ''" class="row-item">
          <div class="bold space">协办部门:</div>
          <div>{{ state.taskDetail.assistOrgName }}</div>
        </div>
        <div class="row-item" v-if="taskContentIsShow">
          <div class="bold space">任务目标:</div>
          <div>{{ state.taskDetail.taskGoal }}</div>
        </div>
        <div class="row-item" v-if="taskContentIsShow">
          <div class="bold space">完成计划:</div>
          <div>{{ state.taskDetail.finishTime }}</div>
        </div>
        <div v-if="state.taskDetail.children">
          <div
            v-for="(item, index) in state.taskDetail.children"
            v-bind:key="index"
            class="row-item"
          >
            <span class="bold space">阶段计划{{ index + 1 }}</span>
            <span class="space">{{ item.taskGoal }}</span>
            <span>{{ getTime(item.finishTime) }}</span>
          </div>
        </div>
        <div class="row-item" v-if="taskContentIsShow">
          <div class="bold space">完成计划:</div>
          <div>{{ state.taskDetail.finishTime }}</div>
        </div>
        <div class="row-item">
          <div class="bold space">任务状态:</div>
          <div>{{ getTaskStatus }}</div>
        </div>
        <div class="row-item">
          <div class="bold space">备注及回复:</div>
          <div>{{ state.taskDetail.comment }}</div>
        </div>
      </div>
    </el-card>

    <el-card v-if="state.showTaskGoal">
      <template #header>
        <div class="card-header">
          <span>确认任务</span>
          <div>
            <el-button type="primary" @click="submitFn">提交</el-button>
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
            <div>
              <span class="space">完成时间</span
              ><el-date-picker v-model="state.childTasksFirst[0].finishTime"></el-date-picker>
            </div>
            <div>
              <span class="space">完成目标</span
              ><el-input
                placeholder="请输入完成目标"
                v-model="state.childTasksFirst[0].taskGoal"
              ></el-input
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
            <div>
              <span class="space">完成时间</span
              ><el-date-picker v-model="state.childTasks[index].finishTime"></el-date-picker>
            </div>
            <div>
              <span class="space">完成目标</span
              ><el-input
                placeholder="请输入完成目标"
                v-model="state.childTasks[index].taskGoal"
              ></el-input>
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
import { dayjs } from 'element-plus'
import TaskModal from '../components/TaskModal.vue'
import { taskDetailReq, appealTaskReq, addSubTaskReq } from '../api/list'
import { orgnizationListIdToName, orgnizationToName } from '../util/orgnization'
import { taskCategoryMap, taskStatusMap } from '../constant/index'
import { toast } from '../util/toast'

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
  childTasksFirst: [
    {
      finishTime: null,
      taskGoal: null
    }
  ],
  childTasks: []
})

const taskContentIsShow = computed(() => {
  if (state.taskDetail.children) {
    return false
  }
  return state.taskDetail.taskGoal !== ''
})

const getTime = computed(() => {
  return function (time) {
    return dayjs(time).format('YYYY-MM-DD')
  }
})

const getTaskStatus = computed(() => {
  return taskStatusMap[state.taskDetail.status]
})

const getTaskDetail = async () => {
  const result = await taskDetailReq({ taskId })
  const {
    data: { category, leadOrg, assistOrg }
  } = result
  state.taskDetail = {
    ...result.data,
    assistOrg: assistOrg === '' ? [] : assistOrg.split(',').map((i) => Number(i)),
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
  state.childTasks.push({
    taskGoal: '',
    finishTime: ''
  })
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
  toast('调整成功！')
  router.replace('/list')
}

const submitFn = async () => {
  const { childTasks, childTasksFirst } = state
  const list = [...childTasksFirst, ...childTasks].map((i) => {
    return {
      ...i,
      finishTime: dayjs(i.finishTime).format(),
      parentId: taskId * 1
    }
  })

  const result = await addSubTaskReq({
    list,
    taskId
  })
  toast()
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
.row-item {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: flex-start;
  margin: 0 0 10px 0;
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
  min-width: 150px;
  text-align: left;
}
.content {
  text-align: left;
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
  user-select: none;
}
</style>
