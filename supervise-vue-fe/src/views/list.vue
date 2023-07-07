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
import { toRefs, reactive, watch, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import QueryHeader from '../components/QueryHeader.vue'
import TaskModal from '../components/TaskModal.vue'
import TableCommon from '../components/TableCommon.vue'
import { taskStatusMap } from '../constant/index'
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
          taskContent: '政企部与市场部联手做好宣传推广，支撑政企业务宣传。',
          group: 1,
          taskGoal: '已完成，4月份政企部提供政企全业务素材至市场部。',
          status: 2,
          comment: ''
        },
        {
          category: 2,
          taskContent: '可研报告里，需要填写专业数据的地方，能否请相关部门（财务、企发）协助。',
          group: 1,
          taskGoal: '企业发展部可牵头协调编制可研中的专业数据等内容。已完成。',
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
      // const result = await getTaskListReq(params)
      // state.tableData = result.data.data
      // state.total = result.data.total
    }
    const handleQuery = (query) => {
      console.log(query)
      state.query = query
      getSuperviseList()
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

    // 监听切换tab 刷新list
    watch(
      () => state.chooseTab,
      (val) => {
        console.log(val, 'changetab')
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
