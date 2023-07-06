<template>
  <QueryHeader type="add" @handleQuery="handleQuery" @createTask="createTask" />
  <div>
    <el-table :data="tableData">
      <el-table-column
        v-for="item in tableColumns"
        :label="item.columnName"
        :prop="item.prop"
      ></el-table-column>
    </el-table>
    <el-pagination
      layout="prev, pager, next"
      :total="tableData.length"
      @size-change="handleSizeChange"
      @page-change="handlePageChange"
    />
  </div>
</template>

<script>
import { toRefs, reactive, watch } from 'vue'
import QueryHeader from '../components/QueryHeader.vue'
import { getTaskListReq } from '../api/list'
export default {
  components: {
    QueryHeader
  },
  setup() {
    const state = reactive({
      page: {
        pageSize: 10,
        pageNum: 1
      },
      querys: {},
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
      total: 0
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
    watch(
      () => state.page,
      (val) => {
        state.page = { ...val }
        getSuperviseList()
      }
    )
    const createTask = () => {
      console.log('create')
    }
    getSuperviseList()
    return {
      ...toRefs(state),
      getSuperviseList,
      handleQuery,
      createTask
    }
  }
}
</script>
