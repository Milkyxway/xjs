<template>
  <QueryReport @handleQuery="handleQuery" />
  <div>
    <TableCommon
      :table-data="state.myTable"
      :table-columns="state.tableColumns"
      @updateTask="updateTask"
      @refreshList="refreshList"
      :total="state.myTableTotal"
      @changePage="changePage"
    />
  </div>
</template>

<script setup>
import { reactive, watch, ref } from 'vue'
import { useRouter } from 'vue-router'
// import QueryHeader from '../components/QueryHeader.vue'
import QueryReport from '../components/QueryReport.vue'
import TableCommon from '../components/TableCommon.vue'
import { getReportListReq } from '../api/report'
import { toast } from '../util/toast'
import { getLocalStore } from '../util/localStorage'
import { dayjs } from 'element-plus'

const userInfo = ref(getLocalStore('userInfo'))
const role = ref(getLocalStore('userInfo').role)
const state = reactive({
  page: {
    pageSize: 10,
    pageNum: 0
  },
  querys: {},

  tableColumns: [
    {
      columnName: '文件名称',
      prop: 'fileName'
    }
  ],
  tableData: [],
  total: 0
})

const getReportList = async () => {}

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

const changePage = (val) => {
  state.page.pageSize = val.pageSize
  state.page.pageNum = val.pageNum - 1
  if (state.chooseTab === 'all') {
    getSuperviseList()
  } else {
    getRelatedMeTask()
  }
}

getReportList()
</script>
