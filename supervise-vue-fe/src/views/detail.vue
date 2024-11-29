<template>
  <div>
    <NavBack />
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
        <div class="row-item" v-if="state.taskDetailCp?.categoryName">
          <div class="bold space">任务类别:</div>
          <div>{{ state.taskDetailCp?.categoryName }}</div>
        </div>
        <div class="row-item">
          <div class="bold space">任务内容:</div>
          <div class="content">{{ state.taskDetailCp.taskContent }}</div>
        </div>
        <div class="row-item">
          <div class="bold space">责任部门:</div>
          <div>{{ state.taskDetailCp.leadOrgName }}</div>
        </div>
        <div v-if="showAssitOrg" class="row-item">
          <div class="bold space">协办部门:</div>
          <div>{{ state.taskDetailCp.assistOrgName }}</div>
        </div>
        <div class="row-item" v-if="state.taskDetailCp.taskGoal">
          <div class="bold space">任务目标:</div>
          <div class="content">{{ state.taskDetailCp.taskGoal }}</div>
        </div>
        <div class="row-item" v-if="state.taskDetailCp.finishTime">
          <div class="bold space">计划完成时间:</div>
          <div>{{ getTime(state.taskDetailCp.finishTime) }}</div>
        </div>
        <div class="row-item" v-if="state.taskDetailCp.actualFinish">
          <div class="bold space">实际完成时间:</div>
          <div>{{ getTime(state.taskDetailCp.actualFinish) }}</div>
        </div>
        <div class="row-item" v-if="state.taskDetailCp.completeDesc">
          <div class="bold space">实际完成情况:</div>
          <div class="content">{{ state.taskDetailCp.completeDesc }}</div>
        </div>
        <div v-if="state.taskDetailCp?.children?.length">
          <div class="row-item">
            <span class="bold space"></span>
            <span class="space task-goal">任务目标</span>
            <span class="space task-goal">完成情况</span>
            <span class="space task-goal">计划完成时间</span>
            <span class="space task-goal">实际完成时间</span>
            <span class="space task-goal">任务状态</span>
          </div>
          <div
            v-for="(item, index) in state.taskDetailCp.children"
            v-bind:key="index"
            class="row-item"
          >
            <span class="bold space">阶段任务{{ index + 1 }}</span>
            <span class="space task-goal">{{ item.taskGoal }}</span>
            <span class="space task-goal">{{ item.completeDesc || '-' }}</span>
            <span class="space task-goal">{{ getTime(item.finishTime) }}</span>
            <span class="space task-goal">{{ getTime(item.actualFinish) }}</span>
            <span :class="['space', 'task-goal', getClassName(item)]">{{
              taskStatusMap[item.status]
            }}</span>
          </div>
        </div>
        <div class="row-item">
          <div class="bold space">任务状态:</div>
          <div :class="getClassName()">{{ getTaskStatus }}</div>
        </div>
        <div class="row-item" v-if="state.taskDetailCp.comment">
          <div class="bold space">备注及回复:</div>
          <div class="content">{{ state.taskDetailCp.comment }}</div>
        </div>
      </div>
    </el-card>

    <div class="white-space"></div>
    <div v-showByAuth="{ role, showCondition: ['section'], otherCondition: state.showTaskGoal }">
      <el-card>
        <template #header>
          <div class="card-header">
            <span class="bold">{{ getTitleByStatus }}</span>
            <div>
              <el-button type="primary" @click="submitFn" v-if="formSubmitShow">提交</el-button>
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
        <el-form v-if="state.showForm" :label-position="'left'">
          <el-form-item label="是否拆分成阶段任务" v-if="state.taskDetail.status === 1"
            ><el-switch v-model="state.hasChildTasks"></el-switch
          ></el-form-item>
          <el-form-item v-if="state.hasChildTasks" label="阶段任务1">
            <ChildTask
              :data="state.childTasksFirst[0]"
              :isFirst="true"
              @addChild="addChild"
              :taskStatus="state.childTasksFirst[0].status"
              @handleItemSubmit="(data) => handleItemSubmit(data, state.childTasksFirst[0].status)"
              :fatherStatus="state.taskDetail.status"
            />
          </el-form-item>
          <el-form-item
            v-for="(item, index) in state.childTasks"
            :label="`阶段任务${index + 2}`"
            v-bind:key="index"
            v-if="state.hasChildTasks"
          >
            <ChildTask
              :data="item"
              :isFirst="false"
              @deleteChild="deleteChild(index)"
              :taskStatus="item.status"
              @handleItemSubmit="(data) => handleItemSubmit(data, item.status)"
              :fatherStatus="state.taskDetail.status"
            />
          </el-form-item>
          <div v-if="!state.hasChildTasks">
            <el-form-item label="完成目标" :label-width="formLabelWidth"
              ><el-input
                v-model="state.formSingle.taskGoal"
                placeholder="请填写完成目标"
                :disabled="state.taskDetail.status !== 1"
                type="textarea"
                rows="3"
              ></el-input
            ></el-form-item>
            <el-form-item label="计划完成时间" :label-width="formLabelWidth"
              ><el-date-picker
                v-model="state.formSingle.finishTime"
                placeholder="请选择计划完成时间"
                :disabled="modifyDisable"
              ></el-date-picker
            ></el-form-item>
            <el-form-item label="实际完成时间" v-if="modifyDisable" :label-width="formLabelWidth"
              ><el-date-picker
                v-model="state.formSingle.actualFinish"
                placeholder="请选择实际完成时间"
              ></el-date-picker
            ></el-form-item>
            <el-form-item label="实际完成情况" v-if="modifyDisable" :label-width="formLabelWidth"
              ><el-input
                placeholder="请输入实际完成情况"
                v-model="state.formSingle.completeDesc"
                type="textarea"
                rows="3"
              ></el-input
            ></el-form-item>
            <el-form-item
              label="延期说明"
              v-if="state.taskDetail.status === 5"
              :label-width="formLabelWidth"
              ><el-input v-model="state.formSingle.delayReason" type="textarea" rows="3"></el-input
            ></el-form-item>
          </div>
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
    </div>
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
import { storeToRefs } from 'pinia'
import { useRoute, useRouter } from 'vue-router'
import { dayjs } from 'element-plus'
import mitt from 'mitt'
import TaskModal from '../components/TaskModal.vue'
import ChildTask from '../components/ChildTask.vue'
import NavBack from '../components/NavBack.vue'
import {
  taskDetailReq,
  appealTaskReq,
  addSubTaskReq,
  updateTaskReq,
  updateSubtaskReq
} from '../api/list'
import { orgnizationListIdToName, orgnizationToName } from '../util/orgnization'
import { taskCategoryMap, taskStatusMap, statusWeight } from '../constant/index'
import { getLocalStore } from '../util/localStorage'
import { toast } from '../util/toast'
import emitter from '../util/eventbus'
import { sectionStore } from '../stores/orgList'

const formLabelWidth = '180px'
const inputForm = ref()
const route = useRoute()
const router = useRouter()

const taskId = route.params.taskId * 1
const userInfo = getLocalStore('userInfo')
const role = userInfo.role
const orgnization = userInfo.orgnization
const region = userInfo.region

const setionStore = sectionStore()
const { sectionList } = storeToRefs(setionStore)

let state = reactive({
  modalVisible: false,
  taskDetail: {},
  taskDetailCp: {},
  showTaskGoal: false,
  hasChildTasks: false,
  childTasksFirst: [
    {
      finishTime: null,
      taskGoal: null,
      comment: null
    }
  ],
  childTasks: [],
  formSingle: {
    taskGoal: '',
    finishTime: '',
    comment: '',
    actualFinish: '',
    comment: '',
    delayReason: ''
  },

  options: [
    {
      label: '非问题仅解释',
      value: 1
    },
    {
      label: '暂时无法解决',
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
      state.formInput.comment = ''
    }
    if (val === '暂时无法解决') {
      state.formInput.comment = `1. 暂时无法解决的原因\n2. 已经做了哪些工作\n3. 后续跟进措施\n`
      state.showForm = false
      state.showInput = true
    }
    state.taskType = val
  }
)
state.taskType = '该问题待解决'

const modifyDisable = computed(() => {
  return [3, 7].includes(state.taskDetail.status)
})

const formSubmitShow = computed(() => {
  const {
    taskDetail: { status },
    hasChildTasks
  } = state
  if (status === 1) {
    return true
  }
  if (hasChildTasks) {
    return false
  }
  return true
})

const getTime = computed(() => {
  return function (time) {
    if (!time) {
      return '-'
    }
    return dayjs(time).format('YYYY-MM-DD')
  }
})

const getTaskStatus = computed(() => {
  const {
    taskDetailCp: { status, finishTime }
  } = state
  // if (status == 5) {
  //   let text = taskStatusMap[status]
  //   const distance = dayjs().diff(dayjs(finishTime), 'day')
  //   return `${text} ${distance}天`
  // }
  return taskStatusMap[status]
})

const showAdjustBtns = computed(() => {
  const { orgnization } = userInfo
  const { taskDetailCp } = state
  if (taskDetailCp.status === 1 && orgnization === taskDetailCp.leadOrg) {
    return true
  }
  return false
})

const getClassName = computed(() => {
  return function (row) {
    let className = ''
    const status = row ? row.status : state.taskDetailCp.status
    switch (status) {
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
      case 6:
        className = 'status-submit'
        break
      case 7:
        className = 'status-delay-process'
        break
      default:
        break
    }
    return className
  }
})

const showAssitOrg = computed(() => {
  return state.taskDetail?.assistOrg && state.taskDetail.assistOrg.length
})

const getTitleByStatus = computed(() => {
  const statusTitleMap = {
    1: '确认任务',
    3: '填写完成情况',
    5: '延期修改',
    7: '填写完成情况'
  }
  return statusTitleMap[state.taskDetailCp.status]
})

const getTaskDetail = async () => {
  await setionStore.getOrgList()
  const result = await taskDetailReq({ taskId })
  if (result.data.taskRegion !== region) {
    router.back()
  }
  const {
    data: { category, leadOrg, assistOrg, finishTime, taskGoal }
  } = result
  state.taskDetail = {
    ...result.data,
    assistOrg: !assistOrg ? [] : assistOrg.split(',').map((i) => Number(i)),
    categoryName: taskCategoryMap[category],
    leadOrgName: orgnizationToName(leadOrg, sectionList.value),
    assistOrgName: orgnizationListIdToName(result.data.assistOrg, sectionList.value)
  }
  state.taskDetailCp = state.taskDetail
  if ([3, 5, 7].includes(result.data.status)) {
    orgnization === result.data.leadOrg && confirmTask() // 只有责任部门能修改任务计划
    if (result.data.children.length) {
      state.hasChildTasks = true
      const child = result.data.children
      state.childTasksFirst = [child[0]]
      state.childTasks = getSecondEnd(child)
    } else {
      state.hasChildTasks = false
      state.formSingle.finishTime = finishTime
      state.formSingle.taskGoal = taskGoal
    }
  }
}
const getSecondEnd = (list) => {
  const arr = []
  for (let i = 1; i < list.length; i++) {
    arr.push(list[i])
  }
  return arr
}

const launchRefresh = () => {
  emitter.emit('refreshList')
}

const handleItemSubmit = async (data, status) => {
  const { actualFinish, finishTime, completeDesc } = data
  const statusProcess = {
    // 状态流转
    1: 3, // 待确认-->进行中
    3: 6, // 进行中-->已提交待管理员置为完成
    5: 7, // 延期-->延期再进行
    7: 6 // 延期再进行 --> 已提交待管理员置为完成
  }
  if ([3, 7].includes(status) && !actualFinish) {
    return toast('请填写实际完成时间', 'error')
  }
  if ([1, 5].includes(status) && dayjs(finishTime).format() < dayjs().format()) {
    return toast('请选择今天及以后的时间', 'error')
  }
  if ([3, 7].includes(status) && dayjs(actualFinish).format() > dayjs(finishTime).format()) {
    return toast('实际完成时间应早于计划完成时间', 'error')
  }
  if ([3, 7].includes(status) && !completeDesc) {
    return toast('请填写完成情况！', 'error')
  }
  await updateSubtaskReq({
    ...data,
    actualFinish: actualFinish ? dayjs(actualFinish).format() : null,
    finishTime: dayjs(finishTime).format(),
    status: statusProcess[status],
    statusWeight: statusWeight[statusProcess[status]]
  })
  toast()
  launchRefresh()
  router.replace('/supervise/list')
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
  await appealTaskReq({
    status: 2,
    comment: form.comment,
    taskId
  })
  state.modalVisible = false
  toast('提交成功！')
  launchRefresh()
  router.replace('/supervise/list')
}

const singleTaskSubmit = async () => {
  const {
    formSingle: { taskGoal, finishTime, comment, actualFinish, completeDesc, delayReason },
    taskDetail: { status }
  } = state
  if (!taskGoal) {
    return toast('请填写完成目标!', 'error')
  }
  if (!finishTime) {
    return toast('请填写计划完成时间!', 'error')
  }
  if ([1, 5].includes(status) && dayjs(finishTime).format() < dayjs().format()) {
    return toast('请选择今天及以后的时间', 'warning')
  }
  if (status === 5 && !delayReason) {
    return toast('请填写延期说明!', 'error')
  }
  if ([3, 7].includes(status) && !actualFinish) {
    return toast('请填写实际完成时间', 'error')
  }

  if ([3, 7].includes(status) && dayjs(actualFinish).format() > dayjs(finishTime).format()) {
    return toast('实际完成时间应晚于计划完成时间', 'warning')
  }
  if ([3, 7].includes(status) && !completeDesc) {
    return toast('请填写实际完成情况', 'error')
  }
  await updateTaskReq(getParamsByStatus(status))
  toast('提交成功！')
  launchRefresh()
  router.replace('/supervise/list')
}

const getParamsByStatus = (taskStatus) => {
  let params = {}
  const {
    formSingle: { taskGoal, finishTime, comment, actualFinish, completeDesc, delayReason }
  } = state

  switch (taskStatus) {
    case 1:
      params = { status: 3 }
      break
    case 5:
      params = { delayReason, status: 7 }
      break
    case 3:
    case 7:
      params = {
        actualFinish: dayjs(actualFinish).format(),
        completeDesc,
        status: 6,
        delayReason: ''
      }
      break
    default:
      break
  }
  return {
    ...params,
    taskGoal,
    finishTime: dayjs(finishTime).format(),
    taskId,
    statusWeight: statusWeight[taskStatus]
  }
}

const subtaskSubmit = async () => {
  const { childTasks, childTasksFirst, taskDetail } = state
  const mergeList = [...childTasksFirst, ...childTasks]
  let unfill = ''
  mergeList.map((i) => {
    if (!i.taskGoal) {
      unfill = '请填写计划完成目标'
    }
    if (!i.finishTime) {
      unfill = '请填写计划完成时间'
    }
    if (dayjs(i.finishTime).format() < dayjs().format()) {
      unfill = '请选择今天及以后的时间'
    }
  })
  if (unfill) {
    return toast(unfill, 'error')
  }
  const list = mergeList.map((i) => {
    return {
      ...i,
      leadOrg: taskDetail.leadOrg,
      finishTime: dayjs(i.finishTime).format(),
      actualFinish: i.actualFinish ? dayjs(i.actualFinish).format() : null,
      parentId: taskId,
      status: 3,
      statusWeight: statusWeight[3]
    }
  })
  await addSubTaskReq({ list, taskId })
  toast('提交成功！')
  launchRefresh()
  router.replace('/supervise/list')
}

const submitFn = async () => {
  const {
    hasChildTasks,
    taskType,
    formInput: { comment }
  } = state
  if (['非问题仅解释', '暂时无法解决'].includes(taskType)) {
    if (
      taskType === '暂时无法解决' &&
      comment == '1. 暂时无法解决的原因\n2. 已经做了哪些工作\n3. 后续跟进措施\n'
    ) {
      return toast('请填写暂时无法解决的原因等', 'error')
    }
    return inputForm.value.validate().then(async (res) => {
      await updateTaskReq({
        taskId,
        completeDesc: comment,
        resolveType: taskType,
        status: taskType === '非问题仅解释' ? 6 : 3, // 暂时无法解决修改为进行中，非问题仅解释改为已提交
        statusWeight: statusWeight[taskType === '非问题仅解释' ? 6 : 3]
      })
      toast('提交成功！')
      launchRefresh()
      router.replace('/supervise/list')
    })
  }
  if (hasChildTasks) {
    subtaskSubmit()
  } else {
    singleTaskSubmit()
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
.status-delay-process {
  color: #e6a23c;
  font-weight: bold;
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
.status-submit {
  color: #0076fe;
}
.white-space {
  height: 10px;
}
.task-goal {
  width: 200px;
}
:deep(.el-date-editor) {
  width: 800px !important;
}
:deep(.el-textarea) {
  width: 800px !important;
}
</style>
