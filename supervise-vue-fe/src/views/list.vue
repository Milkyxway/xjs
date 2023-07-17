<template>
  <QueryHeader type="add" @handleQuery="handleQuery" @createTask="createTask" />
  <div>
    <el-tabs v-model="chooseTab">
      <el-tab-pane label="我的" name="mine" v-if="role !== 'admin'">
        <TableCommon
          :table-data="myTable"
          :table-columns="tableColumns"
          @updateTask="updateTask"
          @deleteTask="deleteTask"
          @setFinish="setFinish"
          @checkTask="checkTask"
          :total="myTableTotal"
          @changePage="changePage"
        />
      </el-tab-pane>
      <el-tab-pane label="所有" name="all">
        <TableCommon
          :table-data="tableData"
          :table-columns="tableColumns"
          @updateTask="updateTask"
          @deleteTask="deleteTask"
          @setFinish="setFinish"
          @checkTask="checkTask"
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
import { ElMessageBox } from 'element-plus'
import { useRouter } from 'vue-router'
import QueryHeader from '../components/QueryHeader.vue'
import TaskModal from '../components/TaskModal.vue'
import TableCommon from '../components/TableCommon.vue'
import {
  getTaskListReq,
  createTaskReq,
  updateTaskReq,
  deleteTaskReq,
  taskSetFinishReq,
  myTaskReq
} from '../api/list'
import { toast } from '../util/toast'
import { getLocalStore } from '../util/localStorage'

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
        appealType: null
      },
      tableColumns: [
        // {
        //   columnName: '序号',
        //   prop: 'index',
        //   type: 'index'
        // },
        {
          columnName: '类别',
          prop: 'category'
        },
        {
          columnName: '专项工作任务',
          prop: 'taskContent'
        },
        {
          columnName: '牵头责任部门',
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
          columnName: '完成计划',
          prop: 'finishTime'
        },
        {
          columnName: '任务状态',
          prop: 'status'
        },
        {
          columnName: '备注',
          prop: 'comment'
        }
      ],
      tableData: [],
      total: 0,
      modalVisible: false
    })

    const getSuperviseList = async () => {
      const params = {
        ...state.page,
        ...state.querys
      }
      const result = await getTaskListReq(params)
      state.tableData = result.data.list.map((i) => {
        return { ...i, hasChildren: i.children.length !== 0 }
      })
      state.total = result.data.total
    }
    const handleQuery = (query) => {
      state.querys = {
        ...query
      }

      getSuperviseList()
    }
    const createTask = () => {
      state.modalVisible = true
      state.modalType = 'add'
      state.formData = {}
    }

    const init = () => {
      getSuperviseList()
      if (role.value === 'admin') {
        state.chooseTab = 'all'
      } else {
        getRelatedMeTask()
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
      state.modalType === 'add' ? await createTaskReq(form) : updateTaskReq(form)
      state.page = {
        pageNum: 0,
        pageSize: 10
      }
      toast()
      getSuperviseList()
      state.modalVisible = false
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
      state.myTable = result.data.list.map((i) => {
        return { ...i, hasChildren: i.children && i.children.length }
      })
      state.myTableTotal = result.data.total
    }

    const deleteTask = async (row) => {
      const { taskId } = row
      ElMessageBox.confirm('确定要删除这项专项任务吗?', '警告', {
        type: 'warning',
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        callback: async (action) => {
          if (action === 'confirm') {
            const result = await deleteTaskReq({ taskId })
            toast()
            getSuperviseList()
          }
        }
      })
    }

    // 置为完成
    const setFinish = async (item) => {
      ElMessageBox.confirm('确定要将这项专项任务置为完成吗?', '警告', {
        type: 'warning',
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        callback: async (action) => {
          if (action === 'confirm') {
            const result = await taskSetFinishReq(item)
            toast()
            getSuperviseList()
          }
        }
      })
    }

    const checkTask = (row) => {
      router.push(`/detail/${row.taskId}`)
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
      deleteTask,
      setFinish,
      checkTask,
      changePage,
      getRelatedMeTask
    }
  }
}
</script>
