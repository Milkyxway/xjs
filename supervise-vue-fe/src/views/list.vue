<template>
  <QueryHeader
    type="add"
    :orgList="sectionList"
    @handleQuery="handleQuery"
    @createTask="createTask"
    @exportAsExcel="exportAsExcel"
  />
  <div>
    <el-tabs v-model="state.chooseTab">
      <el-tab-pane label="我的" name="mine" v-if="['section', 'sub-leader'].includes(role)">
        <TableCommon
          :table-data="state.myTable"
          :table-columns="state.tableColumns"
          @updateTask="updateTask"
          @refreshList="refreshList"
          :total="state.myTableTotal"
          @changePage="changePage"
          @updateFocus="updateFocus"
          :orgList="sectionList"
        />
      </el-tab-pane>
      <el-tab-pane label="已关注" name="focus" v-if="['leader', 'sub-leader'].includes(role)">
        <TableCommon
          :table-data="state.tableFocus"
          :table-columns="state.tableColumns"
          @updateTask="updateTask"
          @refreshList="refreshList"
          :total="state.totalFocus"
          @changePage="changePage"
          @updateFocus="updateFocus"
          :orgList="sectionList"
        />
      </el-tab-pane>
      <el-tab-pane label="所有" name="all">
        <TableCommon
          :table-data="state.tableData"
          :table-columns="state.tableColumns"
          @updateTask="updateTask"
          @refreshList="refreshList"
          :total="state.total"
          @changePage="changePage"
          @updateFocus="updateFocus"
          :orgList="sectionList"
          @addChildTask="addChildTask"
        />
      </el-tab-pane>
      <el-tab-pane
        v-for="(item, index) in state.leaderTabs"
        v-if="['leader', 'sub-leader'].includes(role)"
        :label="item.label"
        :name="item.name"
        v-bind:key="index"
      >
        <TableCommon
          :table-data="state.tableData"
          :table-columns="state.tableColumns"
          @updateTask="updateTask"
          @refreshList="refreshList"
          :total="state.total"
          @changePage="changePage"
          :orgList="sectionList"
      /></el-tab-pane>
    </el-tabs>

    <TaskModal
      :modalVisible="state.modalVisible"
      :modalType="state.modalType"
      @handleCancel="state.modalVisible = false"
      @handle-commit="handleCommit"
      :formData="state.formData"
      :orgList="sectionList"
    />
  </div>
</template>

<script setup>
import { reactive, watch, ref } from 'vue'
import * as xlsx from 'xlsx'
import QueryHeader from '../components/QueryHeader.vue'
import TaskModal from '../components/TaskModal.vue'
import TableCommon from '../components/TableCommon.vue'
import {
  getTaskListReq,
  createTaskReq,
  updateTaskReq,
  myTaskReq,
  getFocusListReq,
  exportDataAsExcelReq,
  updateSubtaskReq,
  addSubTaskReq
} from '../api/list'
import { orgnizationListIdToName, orgnizationToName } from '../util/orgnization'
import { toast } from '../util/toast'
import { getLocalStore } from '../util/localStorage'
import { dayjs } from 'element-plus'
import { statusWeight, taskStatusMap, taskSourceMap } from '../constant/index'
import emitter from '../util/eventbus'
import { storeToRefs } from 'pinia'
import { sectionStore } from '../stores/orgList'

const userInfo = ref(getLocalStore('userInfo'))
const role = ref(getLocalStore('userInfo').role)
const username = ref(getLocalStore('userInfo').username)
const manageParts = ref(getLocalStore('userInfo').manageParts)
const region = ref(getLocalStore('userInfo').region)
const state = reactive({
  chooseTab: 'mine',
  modalType: '',
  page: {
    pageSize: 10,
    pageNum: 0
  },
  myTable: [],
  myTableTotal: 0,
  querys: {},
  formData: {
    category: null,
    taskContent: null,
    leadOrg: null,
    assistOrg: null,
    taskGoal: null,
    status: null,
    comment: null,
    createTime: null,
    ariseOrg: null,
    taskSource: null
  },
  tableColumns: [
    {
      columnName: '序号',
      prop: 'taskId'
    },
    {
      columnName: '关注',
      prop: 'focus'
    },
    {
      columnName: '任务来源',
      prop: 'taskSource'
    },
    {
      columnName: '来源描述',
      prop: 'sourceDesc'
    },
    {
      columnName: '任务类别',
      prop: 'category'
    },
    {
      columnName: '任务内容',
      prop: 'taskContent'
    },
    {
      columnName: '任务状态',
      prop: 'status'
    },
    {
      columnName: '提出部门',
      prop: 'ariseOrg'
    },
    {
      columnName: '牵头部门',
      prop: 'leadOrg'
    },
    {
      columnName: '协办部门',
      prop: 'assistOrg'
    },
    {
      columnName: '任务目标',
      prop: 'taskGoal'
    },
    {
      columnName: '计划完成时间',
      prop: 'finishTime'
    },
    {
      columnName: '实际完成时间',
      prop: 'actualFinish'
    },
    {
      columnName: '实际完成情况',
      prop: 'completeDesc'
    },
    {
      columnName: '完成附件文件',
      prop: 'fileLink'
    },
    {
      columnName: '领导批注',
      prop: 'leadComment'
    },
    {
      columnName: '反馈类型',
      prop: 'resolveType'
    },
    {
      columnName: '延期说明',
      prop: 'delayReason'
    },
    {
      columnName: '创建时间',
      prop: 'createTime'
    },
    {
      columnName: '更新时间',
      prop: 'updateTime'
    }
  ],
  tableData: [],
  total: 0,
  modalVisible: false,
  tableFocus: [],
  totalFocus: 0,
  leaderTabs: [
    {
      label: '专项调研',
      name: 1
    },
    {
      label: '公司重点工作',
      name: 2
    },
    {
      label: '安全检查整改',
      name: 3
    },
    {
      label: '审计整改',
      name: 4
    },
    {
      label: '党委巡察整改',
      name: 5
    },
    {
      label: '市级以上重点任务',
      name: 6
    }
  ]
})
const setionStore = sectionStore()
const { sectionList } = storeToRefs(setionStore)
emitter.on('refreshList', (e) => {
  getListByChooseTab(state.chooseTab)
})

/*const circleOutput = () => {
  const arr = new Array(30)
  arr.fill(1)
  let str = ''
  arr.map((i, k) => {
    str = str + `or a.stand_name like '%漆塘苑%${k + 300}%'\n`
  })
  return str
}
console.log(circleOutput())*/

const getSuperviseList = async () => {
  state.tableData = []
  const params = {
    ...state.page,
    ...state.querys,
    role: role.value,
    taskRegion: region.value
  }
  const result = await getTaskListReq(params)
  state.tableData = insertIdIntoArr(result.data.list)
  state.total = result.data.total
}

const getChildTaskContent = (list) => {
  let str = ''
  list.length
    ? list.map((m, index) => {
        str += `${index + 1}、任务目标:${m.taskGoal};计划完成时间:${dayjs(m.finishTime).format(
          'YYYY-MM-DD'
        )};实际完成时间:${
          m.actualFinish ? dayjs(m.actualFinish).format('YYYY-MM-DD') : '-'
        };实际完成情况:${m.completeDesc};任务状态${taskStatusMap[m.status]}\n`
      })
    : ''
  return str
}

const exportAsExcel = async (query) => {
  await formatQuery(query)
  await setionStore.getOrgList()
  const result = await exportDataAsExcelReq({
    ...state.querys,
    taskRegion: region.value
  })
  const wb = xlsx.utils.book_new()
  const sheet = xlsx.utils.json_to_sheet(
    result.data.list.map((i) => {
      return {
        任务id: i.taskId,
        任务来源: taskSourceMap[i.taskSource],
        来源描述: i.sourceDesc,
        任务内容: i.taskContent,
        提出部门: orgnizationToName(i.ariseOrg, sectionList.value),
        牵头部门: orgnizationToName(i.leadOrg, sectionList.value),
        协办部门: orgnizationListIdToName(i.assistOrg, sectionList.value),
        任务目标: i.taskGoal,
        计划完成时间: dayjs(i.finishTime).format('YYYY-MM-DD'),
        实际完成时间: i.actualFinish ? dayjs(i.actualFinish).format('YYYY-MM-DD') : '',
        实际完成情况: i.completeDesc,
        任务状态: taskStatusMap[i.status],
        领导批注: i.leadComment,
        反馈类型: i.resolveType,
        延期说明: i.delayReason,
        创建时间: dayjs(i.createTime).format('YYYY-MM-DD'),
        更新时间: dayjs(i.updateTime).format('YYYY-MM-DD'),
        子任务情况: getChildTaskContent(i.children)
      }
    })
  )
  xlsx.utils.book_append_sheet(wb, sheet)
  xlsx.writeFile(wb, '导出结果.xlsx')
}

const handleQueryAll = (param) => (param === 0 ? null : param)
const getRangeDateParam = (range) => {
  if (range) {
    return [
      dayjs(range[0]).format('YYYY-MM-DD HH:mm:ss'),
      dayjs(range[1]).format('YYYY-MM-DD HH:mm:ss')
    ]
  }
  return null
}

const formatQuery = (query) => {
  return new Promise((resolve, reject) => {
    try {
      Object.keys(query).map((i) => {
        if (query[i] === '') {
          query[i] = null
        }
      })
      state.querys = {
        ...query,
        taskSource: handleQueryAll(query.taskSource),
        status: handleQueryAll(query.status), // 全部 给后端传null
        category: handleQueryAll(query.category),
        createTime: getRangeDateParam(query.createTime)
      }
      resolve()
    } catch (e) {
      reject(e)
    }
  })
}

const handleQuery = async (query) => {
  await formatQuery(query)
  state.page.pageNum = 0
  state.page.pageSize = 10
  state.chooseTab === 'mine' ? getRelatedMeTask() : getSuperviseList()
}

const createTask = () => {
  state.modalVisible = true
  state.modalType = 'add'
  state.formData = {}
}

/**
 * 满足element的数据结构
 * @param {*} data
 */
const insertIdIntoArr = (data) => {
  const result = data.map((i) => {
    if (i.children.length) {
      i.children = i.children.map((j) => {
        return {
          ...j,
          id: j.subtaskId
        }
      })
      return {
        ...i,
        id: i.taskId,
        isFocus: i.focusBy?.indexOf(username.value) > -1 ? 1 : 0
      }
    }
    return {
      ...i,
      isFocus: i.focusBy?.indexOf(username.value) > -1 ? 1 : 0
    }
  })
  return result
}

const init = async () => {
  await setionStore.getOrgList()
  // getSuperviseList()
  switch (role.value) {
    case 'section': // 部门
      getRelatedMeTask()
      sectionViewTableColumn()
      // 部门权限看不见问题提出部门
      break
    case 'leader': // zhu
      state.chooseTab = 'all'
      leaderViewTableColumn()
      getSuperviseList()
      // todo
      break
    case 'sub-leader': // 分管领导
      subLeaderViewTableColumn()
      getRelatedMeTask()
      break
    case 'employee': // 员工
      state.chooseTab = 'all'
      employeeViewTableColumn()
      getSuperviseList()
      break
    case 'admin': // 管理员
      state.chooseTab = 'all'
      adminViewTableColumn()
      getSuperviseList()
      break
    default:
      break
  }
}

// 监听切换tab 刷新list
watch(
  () => state.chooseTab,
  (val) => {
    getListByChooseTab(val)
  }
)

const getListByChooseTab = (tab) => {
  state.page.pageNum = 0
  state.querys = {}
  switch (tab) {
    case 'mine':
      getRelatedMeTask()
      break
    case 'all':
      getSuperviseList()
      break
    case 'focus':
      getFocusList()
      break
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
      state.querys.taskSource = tab
      getSuperviseList()
      break
    default:
      break
  }
}

const adminViewTableColumn = () => {
  state.tableColumns = state.tableColumns.filter((i) => !['focus'].includes(i.prop))
}

const leaderViewTableColumn = () => {
  state.tableColumns = state.tableColumns.filter(
    (i) =>
      ![
        'assistOrg',
        'createTime',
        'updateTime',
        'sourceDesc',
        'ariseOrg',
        'actualFinish',
        'delayReason',
        'resolveType'
      ].includes(i.prop)
  )
}
const subLeaderViewTableColumn = () => {
  state.tableColumns = state.tableColumns.filter(
    (i) =>
      ![
        'createTime',
        'updateTime',
        'sourceDesc',
        'ariseOrg',
        'actualFinish',
        'delayReason',
        'resolveType'
      ].includes(i.prop)
  )
}

const employeeViewTableColumn = () => {
  state.tableColumns = state.tableColumns.filter(
    (i) =>
      ![
        'assistOrg',
        'taskGoal',
        'finishTime',
        'sourceDesc',
        'ariseOrg',
        'updateTime',
        'createTime',
        'delayReason',
        'resolveType',
        'focus',
        'leaderComment'
      ].includes(i.prop)
  )
}

const sectionViewTableColumn = () => {
  state.tableColumns = state.tableColumns.filter(
    (i) => !['sourceDesc', 'ariseOrg', 'focus'].includes(i.prop)
  )
}
// 弹窗里确定按钮触发
const handleCommit = async (form) => {
  const {
    assistOrg,
    category,
    taskContent,
    leadOrg,
    comment,
    taskId,
    ariseOrg,
    taskGoal,
    finishTime,
    actualFinish,
    completeDesc,
    taskSource,
    status,
    sourceDesc
  } = form
  let params = form
  if (!ariseOrg) {
    const { ariseOrg, ...rest } = form
    params = rest
  }
  let result

  if (state.modalType === 'add' && form.isSubtask) {
    // 增加子任务
    result = await addSubTaskReq({ ...form })
  }
  if (state.modalType === 'add' && !form.isSubtask) {
    // 创建主任务
    result = await createTaskReq({
      ...params,
      statusWeight: statusWeight[1],
      taskRegion: region.value
    })
  }
  if (state.modalType === 'update' && form.isSubtask) {
    result = await updateSubtaskReq({
      // 子任务修改
      parentId: form.parentId,
      status: [1, 2].includes(status) ? 1 : status,
      statusWeight: [1, 2].includes(status) ? statusWeight[1] : statusWeight[status],
      subtaskId: form.subtaskId,
      taskGoal: status === 1 ? null : taskGoal, // 调整成待确认 用户手动填写的全部清空
      finishTime: status === 1 ? null : finishTime ? dayjs(finishTime).format() : null,
      actualFinish: status === 1 ? null : actualFinish ? dayjs(actualFinish).format() : null,
      completeDesc: status === 1 ? null : completeDesc
    })
  }
  if (state.modalType === 'update' && !form.isSubtask) {
    result = await updateTaskReq({
      // 父级任务修改
      assistOrg,
      category,
      taskContent,
      leadOrg,
      comment,
      status: [1, 2].includes(status) ? 1 : status,
      statusWeight: [1, 2].includes(status) ? statusWeight[1] : statusWeight[status],
      taskId,
      taskGoal: status === 1 ? null : taskGoal, // 调整成待确认 用户手动填写的全部清空
      finishTime: status === 1 ? null : finishTime ? dayjs(finishTime).format() : null,
      actualFinish: status === 1 ? null : actualFinish ? dayjs(actualFinish).format() : null,
      completeDesc: status === 1 ? null : completeDesc,
      taskSource,
      sourceDesc,
      ariseOrg: form.ariseOrg
    })
  }

  // state.modalType === 'update' &&
  //   !form.isSubtask &&
  //   [1, 2].includes(status) &&
  //   deleteSubTaskReq({ parentId: taskId }) // 从别的状态改成待确认会清空所有的子任务

  state.page = {
    pageNum: 0,
    pageSize: 10
  }

  if (result.code === 200) {
    refreshList()
    state.modalVisible = false
  }
}

const updateTask = (row) => {
  state.modalType = 'update'
  state.modalVisible = true
  state.formData = {
    ...row,
    assistOrg: !row.assistOrg ? [] : row.assistOrg.split(',').map((i) => Number(i))
  }
}

const addChildTask = (row) => {
  state.modalType = 'add'
  state.modalVisible = true
  state.formData = {
    ...row.children[0],
    taskGoal: '',
    finishTime: '',
    actualFinish: '',
    completeDesc: '',
    parentId: row.taskId,
    subtaskId: ''
  }
}

const getRelatedMeTask = async () => {
  let params = {
    ...state.page,
    ...state.querys
  }
  if (role.value === 'section') {
    params = {
      ...params,
      orgnizationId: userInfo.value.orgnization
    }
  } else if (role.value === 'sub-leader') {
    params = {
      ...params,
      role: role.value,
      manageParts: manageParts.value
    }
  }
  const result = await myTaskReq(params)
  state.myTable = insertIdIntoArr(result.data.list)
  state.myTableTotal = result.data.total
}

const getFocusList = async () => {
  const result = await getFocusListReq({ username: username.value, ...state.page })
  state.tableFocus = insertIdIntoArr(result.data.list)
  state.totalFocus = result.data.total
}

const changePage = (val) => {
  state.page.pageSize = val.pageSize
  state.page.pageNum = val.pageNum - 1
  if (['all', 1, 2, 3, 4, 5].includes(state.chooseTab)) {
    getSuperviseList()
  } else {
    getRelatedMeTask()
  }
}

const refreshList = () => {
  toast()
  getSuperviseList()
  if (['section', 'sub-leader'].includes(role.value)) {
    getRelatedMeTask()
  }
}

const updateFocus = (params) => {
  const { taskId, isFocus } = params
  const { chooseTab } = state
  let type = ''
  switch (chooseTab) {
    case 'mine':
      type = 'myTable'
      break
    case 'all':
      type = 'tableData'
      break
    case 'focus':
      getFocusList()
      break
  }
  if (['mine', 'all'].includes(chooseTab)) {
    state[type] = state[type].map((i) => {
      if (i.taskId === taskId) {
        return {
          ...i,
          isFocus
        }
      }
      return i
    })
  }
}

init()
</script>
