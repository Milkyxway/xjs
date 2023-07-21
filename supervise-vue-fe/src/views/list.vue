<template>
  <QueryHeader type="add" @handleQuery="handleQuery" @createTask="createTask" />
  <div>
    <el-tabs v-model="chooseTab">
      <el-tab-pane label="我的" name="mine" v-if="role !== 'admin'">
        <TableCommon
          :table-data="myTable"
          :table-columns="tableColumns"
          @updateTask="updateTask"
          @refreshList="refreshList"
          :total="myTableTotal"
          @changePage="changePage"
        />
      </el-tab-pane>
      <el-tab-pane label="所有" name="all">
        <TableCommon
          :table-data="tableData"
          :table-columns="tableColumns"
          @updateTask="updateTask"
          @refreshList="refreshList"
          :total="total"
          @changePage="changePage"
        />
      </el-tab-pane>
    </el-tabs>

    <TaskModal
      :modalVisible="modalVisible"
      :modalType="modalType"
      @handleCancel="modalVisible = false"
      @handle-commit="handleCommit"
      :formData="formData"
    />
  </div>
</template>

<script>
import { toRefs, reactive, watch, ref } from 'vue'
import { useRouter } from 'vue-router'
import QueryHeader from '../components/QueryHeader.vue'
import TaskModal from '../components/TaskModal.vue'
import TableCommon from '../components/TableCommon.vue'
import { getTaskListReq, createTaskReq, updateTaskReq, myTaskReq } from '../api/list'
import { toast } from '../util/toast'
import { getLocalStore } from '../util/localStorage'
import { dayjs } from 'element-plus'

export default {
  components: {
    QueryHeader,
    TaskModal,
    TableCommon
  },
  setup() {
    const userInfo = ref(getLocalStore('userInfo'))
    const role = ref(getLocalStore('userInfo').role)
    const router = useRouter()
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
        ariseOrg: null
        // appealType: null
      },
      tableColumns: [
        {
          columnName: '类别',
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
          columnName: '任务状态',
          prop: 'status'
        },
        {
          columnName: '反馈类型',
          prop: 'resolveType'
        },
        {
          columnName: '反馈',
          prop: 'comment'
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
      modalVisible: false
    })

    const getSuperviseList = async () => {
      state.tableData = []
      const params = {
        ...state.page,
        ...state.querys
      }
      const result = await getTaskListReq(params)
      state.tableData = insertIdIntoArr(result.data.list)
      state.total = result.data.total
    }
    const handleQuery = (query) => {
      Object.keys(query).map((i) => {
        if (query[i] === '') {
          query[i] = null
        }
      })
      state.querys = {
        ...query,
        createTime: dayjs(query.createTime).year()
      }
      state.page.pageNum = 0
      state.page.pageSize = 10

      getSuperviseList()
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
      if (role.value === 'admin') {
        state.chooseTab = 'all'
      } else {
        getRelatedMeTask()
        state.tableColumns = state.tableColumns.filter((i) => i.prop !== 'ariseOrg') // 部门权限看不见问题提出部门
      }
    }

    // 监听切换tab 刷新list
    watch(
      () => state.chooseTab,
      (val) => {
        state.page.pageNum = 0
        if (val === 'mine') {
          getRelatedMeTask()
        } else {
          getSuperviseList()
        }
      }
    )

    // 弹窗里确定按钮触发
    const handleCommit = async (form) => {
      const { assistOrg, category, taskContent, leadOrg, comment, taskId } = form
      const result =
        state.modalType === 'add'
          ? await createTaskReq(form)
          : await updateTaskReq({
              assistOrg,
              category,
              taskContent,
              leadOrg,
              comment,
              status: 1,
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
        orgnizationId: userInfo.value.orgnization
      })
      state.myTable = insertIdIntoArr(result.data.list)
      state.myTableTotal = result.data.total
    }

    const changePage = (val) => {
      state.page.pageSize = val.pageSize
      state.page.pageNum = val.pageNum - 1
      if (state.chooseTab === 'all') {
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

    return {
      ...toRefs(state),
      userInfo,
      role,
      getSuperviseList,
      handleQuery,
      handleCommit,
      createTask,
      updateTask,
      refreshList,
      changePage,
      getRelatedMeTask
    }
  }
}
</script>
