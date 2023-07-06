<template>
  <QueryHeader type="add" @handleQuery="handleQuery" @createTask="createTask" />
  <div>
    <el-table :data="tableData">
      <el-table-column
        v-for="item in tableColumns"
        :label="item.columnName"
        :prop="item.prop"
      ></el-table-column>
      <el-table-column fixed="right" label="操作" width="120">
        <template #default="{ row }">
          <el-button link type="primary" size="small" @click="updateTask(row)">修改</el-button>
          <el-button link type="primary" size="small" @click="deleteTask(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      layout="prev, pager, next"
      :total="tableData.length"
      @size-change="handleSizeChange"
      @page-change="handlePageChange"
    />
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
import { ElMessage, ElMessageBox } from 'element-plus'
import QueryHeader from '../components/QueryHeader.vue'
import TaskModal from '../components/TaskModal.vue'
import { getTaskListReq, createTaskReq, updateTaskReq, deleteTaskReq } from '../api/list'
export default {
  components: {
    QueryHeader,
    TaskModal
  },
  setup() {
    const state = reactive({
      modalType: '',
      page: {
        pageSize: 10,
        pageNum: 1
      },
      querys: {},
      formData: {
        name: '',
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

      tableData: [
        {
          category: 1,
          taskContent:
            '在营销政策上建议给长期在网或充值额度高的忠实用户给予更多关怀，可以赠送一些小礼品等。',
          group: 1,
          taskGoal: '在“迎春杯”和“春雷行动”的活动政策中均有体现。',
          status: 1,
          comment: ''
        },
        {
          category: 1,
          taskContent:
            '在营销政策上建议给长期在网或充值额度高的忠实用户给予更多关怀，可以赠送一些小礼品等。',
          group: 1,
          taskGoal: '在“迎春杯”和“春雷行动”的活动政策中均有体现。',
          status: 1,
          comment: ''
        },
        {
          category: 1,
          taskContent:
            '今年出台奖励措施，智慧广电第一年是10%，第二年降到2%，考虑3年以后还要续签，建议提高奖励，便于长久维系客户关系。',
          group: 1,
          taskGoal:
            '经研究，按照智慧广电乡村工程长效运营要求，第二年，第三年在原有工程基础上有新业态发展及点击率，曝光率有显著增加的地区，参照第一年奖励比例提高。',
          status: 1,
          comment: ''
        },
        {
          category: 1,
          taskContent:
            '在营销政策上建议给长期在网或充值额度高的忠实用户给予更多关怀，可以赠送一些小礼品等。',
          group: 1,
          taskGoal: '在“迎春杯”和“春雷行动”的活动政策中均有体现。',
          status: 1,
          comment: ''
        }
      ],
      total: 0,
      modalVisible: false
    })

    const getSuperviseList = async () => {
      const params = {
        ...state.page,
        ...state.querys
      }
      const result = await getTaskListReq(params)
      state.tableData = result.data.data
      state.total = result.data.total
    }
    const handleQuery = () => {
      console.log('query')
    }
    const createTask = () => {
      state.modalVisible = true
      state.modalType = 'add'
    }
    watch(
      () => state.page, //监听分页器的变化
      (val) => {
        state.page = { ...val }
        getSuperviseList()
      },
      {
        immediate: true
      }
    )

    // 弹窗里确定按钮触发
    const handleCommit = async (form) => {
      const result = state.modalType === 'add' ? await createTaskReq(form) : updateTaskReq(form)
      state.page = {
        pageNum: 1,
        pageSize: 10
      }

      state.modalVisible = false
    }
    const updateTask = (row) => {
      state.modalType = 'update'
      state.modalVisible = true
      state.formData = { ...row }
    }
    const deleteTask = () => {
      ElMessageBox.alert('This is a message', 'Title', {
        // if you want to disable its autofocus
        // autofocus: false,
        confirmButtonText: 'OK',
        callback: (action) => {
          ElMessage({
            type: 'info',
            message: `action: ${action}`
          })
        }
      })
    }
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
      handleSizeChange
    }
  }
}
</script>
