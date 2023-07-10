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
        />
        <el-pagination
          layout="prev, pager, next"
          :total="tableData.length"
          @size-change="handleSizeChange"
          @page-change="handlePageChange"
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
          :total="tableData.length"
          @size-change="handleSizeChange"
          @page-change="handlePageChange"
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
import { ElMessage, ElLoading, ElMessageBox } from 'element-plus'
import QueryHeader from '../components/QueryHeader.vue'
import TaskModal from '../components/TaskModal.vue'
import TableCommon from '../components/TableCommon.vue'
import { getTaskListReq, createTaskReq, updateTaskReq, deleteTaskReq } from '../api/list'
export default {
  components: {
    QueryHeader,
    TaskModal,
    TableCommon
  },
  setup() {
    const state = reactive({
      chooseTab: 'mine',
      modalType: '',
      page: {
        pageSize: 10,
        pageNum: 0
      },
      querys: {},
      formData: {
        category: '',
        taskContent: '',
        orgnization: '',
        taskGoal: '',
        status: '',
        comment: ''
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
          prop: 'orgnization'
        },
        {
          columnName: '协办部门',
          prop: 'assist'
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
    }
    const handleQuery = (query) => {
      state.query = query
      getSuperviseList()
    }
    const createTask = () => {
      state.modalVisible = true
      state.modalType = 'add'
      state.formData = {}
    }
    watch(
      () => state.page, //监听分页器的变化
      (val) => {
        state.page = { ...val }
        // getSuperviseList()
      },
      {
        immediate: true
      }
    )

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
      ElMessage({
        message: '操作成功！',
        type: 'info'
      })
      getSuperviseList()
      state.modalVisible = false
    }

    const updateTask = (row) => {
      state.modalType = 'update'
      state.modalVisible = true
      state.formData = { ...row }
    }
    const deleteTask = async () => {
      const result = await deleteTaskReq({})
      getSuperviseList()
      // ElMessageBox.confirm('It will permanently delete the file. Continue?', 'Warning', {
      //   type: 'warning',
      //   icon: markRaw(Delete)
      // })
    }

    // 置为完成
    const setFinish = () => {}

    getSuperviseList()

    const handlePageChange = () => {}
    const handleSizeChange = () => {}
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
      setFinish
    }
  }
}
</script>
