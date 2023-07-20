<template>
  <div>
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span class="bold">任务详情</span>
          <div v-if="showAdjustBtns">
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
        <div v-if="showAssitOrg" class="row-item">
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
          <div :class="getClassName">{{ getTaskStatus }}</div>
        </div>
        <div class="row-item" v-if="state.taskDetail.comment">
          <div class="bold space">备注及回复:</div>
          <div>{{ state.taskDetail.comment }}</div>
        </div>
      </div>
    </el-card>

    <div class="white-space"></div>
    <el-card v-if="state.showTaskGoal">
      <template #header>
        <div class="card-header">
          <span>{{ getTitleByStatus }}</span>
          <div>
            <el-button type="primary" @click="submitFn">提交</el-button>
          </div>
        </div>
      </template>
      <el-radio-group v-model="state.taskType" v-if="state.taskDetail.status === 1">
        <el-radio
          v-for="(item, index) in state.options"
          :label="item.label"
          :name="item.name"
          v-bind:key="index"
          >{{ item.label }}</el-radio
        >
      </el-radio-group>
      <el-form v-if="state.showForm">
        <el-form-item label="是否拆分成阶段任务" v-if="state.taskDetail.status === 1"
          ><el-switch v-model="state.hasChildTasks"></el-switch
        ></el-form-item>
        <el-form-item v-if="state.hasChildTasks" label="阶段任务1">
          <ChildTask :data="state.childTasksFirst[0]" :isFirst="true" @addChild="addChild" />
        </el-form-item>
        <el-form-item
          v-for="(item, index) in state.childTasks"
          :label="`阶段任务${index + 2}`"
          v-bind:key="index"
        >
          <ChildTask :data="item" :isFirst="false" @deleteChild="deleteChild(index)" />
        </el-form-item>
        <el-form-item v-if="!state.hasChildTasks">
          <el-form-item label="完成目标"
            ><el-input v-model="state.formSingle.taskGoal"></el-input
          ></el-form-item>
          <el-form-item label="完成时间"
            ><el-date-picker v-model="state.formSingle.finishTime"></el-date-picker
          ></el-form-item>
          <el-form-item label="延期说明" v-if="state.taskDetail.status === 5"
            ><el-date-picker v-model="state.formSingle.comment"></el-date-picker
          ></el-form-item>
        </el-form-item>
      </el-form>
      <el-form v-if="state.showInput" ref="inputForm" :model="state.formInput">
        <el-form-item
          label="详细解释"
          :rules="[{ required: true, message: '请输入详细解释', trigger: 'blur' }]"
          prop="comment"
        >
          <el-input
            type="textarea"
            rows="3"
            v-if="state.showInput"
            placeholder="请输入详细解释"
            v-model="state.formInput.comment"
          ></el-input>
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
import { reactive, computed, watch, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { dayjs } from 'element-plus'
import TaskModal from '../components/TaskModal.vue'
import ChildTask from '../components/ChildTask.vue'
import {
  taskDetailReq,
  appealTaskReq,
  addSubTaskReq,
  updateTaskReq,
  updateSubtaskReq
} from '../api/list'
import { orgnizationListIdToName, orgnizationToName } from '../util/orgnization'
import { taskCategoryMap, taskStatusMap } from '../constant/index'
import { getLocalStore } from '../util/localStorage'
import { toast } from '../util/toast'

const inputForm = ref()
const route = useRoute()
const router = useRouter()

const taskId = route.params.taskId
const userInfo = getLocalStore('userInfo')

let state = reactive({
  modalVisible: false,
  taskDetail: {},
  showTaskGoal: false,
  hasChildTasks: false,
  childTasksFirst: [
    {
      finishTime: null,
      taskGoal: null,
      delayReason: null
    }
  ],
  childTasks: [],
  formSingle: {
    taskGoal: '',
    finishTime: '',
    comment: ''
  },

  options: [
    {
      label: '非问题仅解释',
      value: 1
    },
    {
      label: '该问题已完成',
      value: 2
    },
    {
      label: '该问题待解决',
      value: 3
    }
  ],
  taskType: '',
  showForm: false,
  showInput: false,
  formInput: {
    comment: ''
  }
})

watch(
  () => state.taskType,
  (val) => {
    if (val === '该问题待解决') {
      state.showForm = true
      state.showInput = false
    } else {
      state.showForm = false
      state.showInput = true
    }
  }
)
state.taskType = '该问题待解决'
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

const showAdjustBtns = computed(() => {
  const { orgnization } = userInfo
  const { taskDetail } = state
  if (taskDetail.status === 1 && orgnization === taskDetail.leadOrg) {
    return true
  }
  return false
})

const getClassName = computed(() => {
  // return function (row) {
  let className = ''
  switch (state.taskDetail.status) {
    case 1: //
      className = 'status-confirm'
      break
    case 2:
      className = 'status-adjust'
      break
    case 3:
      className = 'status-processing'
      break
    case 4:
      className = 'status-finish'
      break
    case 5:
      className = 'status-delay'
      break
    default:
      break
  }
  return className
  // }
})

const showAssitOrg = computed(() => {
  return state.taskDetail?.assistOrg && state.taskDetail.assistOrg.length
})

const getTitleByStatus = computed(() => {
  const statusTitleMap = {
    1: '确认任务',
    5: '修改任务'
  }
  return statusTitleMap[state.taskDetail.status]
})

const getTaskDetail = async () => {
  const result = await taskDetailReq({ taskId })
  const {
    data: { category, leadOrg, assistOrg, finishTime, taskGoal }
  } = result
  state.taskDetail = {
    ...result.data,
    assistOrg: assistOrg === '' ? [] : assistOrg.split(',').map((i) => Number(i)),
    categoryName: taskCategoryMap[category],
    leadOrgName: orgnizationToName(leadOrg),
    assistOrgName: orgnizationListIdToName(result.data.assistOrg)
  }
  if (result.data.status === 5) {
    confirmTask()

    if (result.data.children.length) {
      state.hasChildTasks = true
      const child = result.data.children
      state.childTasksFirst = [child[0]]
      child.shift()
      state.childTasks = child
    } else {
      state.hasChildTasks = false
      state.formSingle.finishTime = finishTime
      state.formSingle.taskGoal = taskGoal
    }
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
    finishTime: '',
    delayReason: ''
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
  toast('提交成功！')
  router.replace('/supervise/list')
}

const submitFn = async () => {
  const {
    childTasks,
    childTasksFirst,
    hasChildTasks,
    taskType,
    taskDetail,
    formInput: { comment }
  } = state
  if (['非问题仅解释', '该问题已完成'].includes(taskType)) {
    return inputForm.value.validate().then(async (res) => {
      await updateTaskReq({
        taskId: taskId * 1,
        comment,
        resolveType: taskType,
        status: 3
      })
      toast('提交成功！')
      router.replace('/supervise/list')
    })
  }
  if (hasChildTasks) {
    const list = [...childTasksFirst, ...childTasks].map((i) => {
      return {
        ...i,
        leadOrg: taskDetail.leadOrg,
        finishTime: dayjs(i.finishTime).format(),
        parentId: taskId * 1,
        status: 3
      }
    })

    taskDetail.status === 1
      ? await addSubTaskReq({
          list,
          taskId
        })
      : await updateSubtaskReq({ list, taskId })
    toast('提交成功！')
    router.replace('/supervise/list')
  } else {
    await updateTaskReq({
      ...state.formSingle,
      finishTime: dayjs(state.formSingle.finishTime).format(),
      taskId: taskId * 1,
      status: 3
    })
    toast('提交成功！')
    router.replace('/supervise/list')
  }
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
  align-items: center;
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
  align-items: flex-start;
}
.inline-wrap {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: center;
  white-space: nowrap;
  user-select: none;
}
.status-finish {
  color: #67c23a;
}
.status-processing {
  color: #e6a23c;
}
.status-confirm {
  color: #f56c6c;
}
.status-delay {
  color: #f56c6c;
  font-weight: bold;
}
.status-adjust {
  color: #b1b3b8;
}
.white-space {
  height: 10px;
}
</style>
