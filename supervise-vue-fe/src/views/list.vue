<template>
  <QueryHeader type="add" @handleQuery="handleQuery" @createTask="createTask" />
  <div>
    <el-tabs v-model="state.chooseTab">
      <el-tab-pane label="我的" name="mine" v-if="role === 'section'">
        <TableCommon
          :table-data="state.myTable"
          :table-columns="state.tableColumns"
          @updateTask="updateTask"
          @refreshList="refreshList"
          :total="state.myTableTotal"
          @changePage="changePage"
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
        />
      </el-tab-pane>
      <el-tab-pane
        v-for="(item, index) in state.leaderTabs"
        v-if="['leader'].includes(role)"
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
      /></el-tab-pane>
    </el-tabs>

    <TaskModal
      :modalVisible="state.modalVisible"
      :modalType="state.modalType"
      @handleCancel="state.modalVisible = false"
      @handle-commit="handleCommit"
      :formData="state.formData"
    />
  </div>
</template>

<script setup>
import { reactive, watch, ref } from 'vue'
import { useRouter } from 'vue-router'
import QueryHeader from '../components/QueryHeader.vue'
import TaskModal from '../components/TaskModal.vue'
import TableCommon from '../components/TableCommon.vue'
import { getTaskListReq, createTaskReq, updateTaskReq, myTaskReq } from '../api/list'
import { toast } from '../util/toast'
import { getLocalStore } from '../util/localStorage'
import { dayjs } from 'element-plus'
import { statusWeight } from '../constant/index'

const userInfo = ref(getLocalStore('userInfo'))
const role = ref(getLocalStore('userInfo').role)
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
      columnName: '任务状态',
      prop: 'status'
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
    }
  ]
})

const getSuperviseList = async () => {
  state.tableData = []
  const params = {
    ...state.page,
    ...state.querys,
    role: role.value
  }
  const result = await getTaskListReq(params)
  state.tableData = insertIdIntoArr(result.data.list)
  state.total = result.data.total
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

const handleQuery = (query) => {
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
        id: i.taskId
      }
    }
    return i
  })
  return result
}

const init = () => {
  getSuperviseList()
  switch (role.value) {
    case 'section':
      getRelatedMeTask()
      sectionViewTableColumn()
      // 部门权限看不见问题提出部门
      break
    case 'leader':
      state.chooseTab = 'all'
      leaderViewTableColumn()
      break
    case 'employee':
      state.chooseTab = 'all'
      employeeViewTableColumn()
      break
    case 'admin':
      state.chooseTab = 'all'
      break
    default:
      break
  }
}

// 监听切换tab 刷新list
watch(
  () => state.chooseTab,
  (val) => {
    state.page.pageNum = 0
    state.querys = {}
    switch (val) {
      case 'mine':
        getRelatedMeTask()
        break
      case 'all':
        getSuperviseList()
        break
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        state.querys.taskSource = val
        getSuperviseList()
        break
      default:
        break
    }
  }
)

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
        'resolveType'
      ].includes(i.prop)
  )
}

const sectionViewTableColumn = () => {
  state.tableColumns = state.tableColumns.filter(
    (i) => !['sourceDesc', 'ariseOrg'].includes(i.prop)
  )
}
// 弹窗里确定按钮触发
const handleCommit = async (form) => {
  const { assistOrg, category, taskContent, leadOrg, comment, taskId, ariseOrg } = form
  let params = form
  if (!ariseOrg) {
    const { ariseOrg, ...rest } = form
    params = rest
  }
  const result =
    state.modalType === 'add'
      ? await createTaskReq({ ...params, statusWeight: statusWeight[1] })
      : await updateTaskReq({
          assistOrg,
          category,
          taskContent,
          leadOrg,
          comment,
          status: 1,
          statusWeight: statusWeight[1],
          taskId
        })
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
    assistOrg: row.assistOrg === '' ? [] : row.assistOrg.split(',').map((i) => Number(i))
  }
}

const getRelatedMeTask = async () => {
  const result = await myTaskReq({
    ...state.page,
    ...state.querys,
    orgnizationId: userInfo.value.orgnization
  })
  state.myTable = insertIdIntoArr(result.data.list)
  state.myTableTotal = result.data.total
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
  role.value !== 'admin' && getRelatedMeTask()
}

init()
</script>
