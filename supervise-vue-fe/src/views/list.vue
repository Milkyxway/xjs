<template>
  <QueryHeader type="add" @handleQuery="handleQuery" @createTask="createTask" />
  <div>
    <el-tabs v-model="chooseTab">
      <el-tab-pane label="我的" name="mine">
        <TableCommon
          :table-data="tableData"
          :table-columns="tableColumns"
          @updateTask="updateTask"
          @deleteTask="deleteTask"
          @setFinish="setFinish"
          @checkTask="checkTask"
        />

        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="page.pageSize"
          :page-sizes="[10, 20, 30, 40]"
          :small="small"
          layout="sizes, prev, pager, next"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handlePageChange"
        />
      </el-tab-pane>
      <el-tab-pane label="所有" name="all">
        <TableCommon
          :table-data="tableData"
          :table-columns="tableColumns"
          @updateTask="updateTask"
          @deleteTask="deleteTask"
          @setFinish="setFinish"
        />
        <el-pagination
          layout="prev, pager, next"
          :page-sizes="[20, 40, 60, 80]"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handlePageChange"
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
import { toRefs, reactive, watch } from 'vue'
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
  taskSetFinishReq
} from '../api/list'
import { toast } from '../util/toast'

export default {
  components: {
    QueryHeader,
    TaskModal,
    TableCommon
  },
  setup() {
    const router = useRouter()
    const state = reactive({
      chooseTab: 'mine',
      modalType: '',
      page: {
        pageSize: 10,
        pageNum: 0
      },
      querys: {},
      formData: {
        category: null,
        taskContent: '',
        leadOrg: null,
        assistOrg: null,
        taskGoal: '',
        status: null,
        comment: '',
        createTime: null
      },
      tableColumns: [
        {
          columnName: '序号',
          prop: 'index'
        },
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
          columnName: '完成计划',
          prop: 'taskGoal'
        },
        {
          columnName: '完成情况',
          prop: 'status'
        },
        {
          columnName: '备注',
          prop: 'comment'
        }
      ],
      tableData: [],
      total: 0,
      currentPage: 1,
      modalVisible: false
    })

    const getSuperviseList = async () => {
      const params = {
        ...state.page,
        ...state.querys
      }
      const result = await getTaskListReq(params)
      state.tableData = result.data.list
      state.total = result.data.total
      state.currentPage = 1
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

    // 监听切换tab 刷新list
    watch(
      () => state.chooseTab,
      (val) => {
        console.log(val, 'changetab')
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
      const result = await taskSetFinishReq(item)
      toast()
      getSuperviseList()
    }

    getSuperviseList()

    const handlePageChange = (val) => {
      state.page.pageNum = val - 1
      state.currentPage = val
      getSuperviseList()
    }
    const handleSizeChange = (val) => {
      state.page.pageSize = val
      getSuperviseList()
    }

    const checkTask = (row) => {
      router.push(`/detail/${row.taskId}`)
    }

    return {
      ...toRefs(state),
      getSuperviseList,
      handleQuery,
      handleCommit,
      createTask,
      updateTask,
      deleteTask,
      handlePageChange,
      handleSizeChange,
      setFinish,
      checkTask
    }
  }
}
</script>
