<template>
  <div>
    <el-table
      :data="props.tableData"
      row-key="id"
      :default-expand-all="false"
      :row-class-name="(row) => getRowClassName(row)"
    >
      <el-table-column
        v-for="item in props.tableColumns"
        :label="item.columnName"
        :prop="item.prop"
        :key="item.key"
        :width="['taskContent', 'taskGoal'].includes(item.prop) && 180"
      >
        <template #default="{ row }">
          <span v-if="item.prop === 'status'" :class="getClassName(row)">{{
            getStatusName(row)
          }}</span>
          <span v-if="item.prop === 'category'">{{ getCategoryName(row) }}</span>
          <span v-if="['leadOrg', 'assistOrg', 'ariseOrg'].includes(item.prop)">{{
            getOrgName(row, item.prop)
          }}</span>
          <span
            v-if="['finishTime', 'createTime', 'updateTime', 'actualFinish'].includes(item.prop)"
            >{{ getTime(row, item.prop) }}</span
          >
          <span v-if="item.prop === 'taskSource'">{{ getTaskSourceName(row) }}</span>
          <span
            v-if="['taskContent', 'completeDesc', 'comment'].includes(item.prop)"
            :class="isExpand ? 'task-content-expand' : 'task-content'"
            >{{ row[item.prop] }}</span
          >
          <!-- <span v-if="item.prop === 'taskContent'" @click="expandAll">展开</span> -->
        </template></el-table-column
      >

      <el-table-column fixed="right" label="操作" width="150">
        <template #default="{ row }">
          <el-button
            link
            type="primary"
            size="small"
            @click="checkTask(row)"
            v-showByAuth="{
              role,
              showCondition: ['admin', 'section', 'leader', 'employee']
            }"
            >查看</el-button
          >
          <el-button
            link
            type="primary"
            size="small"
            @click="updateTask(row)"
            v-showByAuth="{
              role,
              showCondition: ['admin'],
              otherCondition: [1, 2].includes(row.status)
            }"
            >修改</el-button
          >
          <el-button
            link
            type="primary"
            size="small"
            @click="deleteTask(row)"
            v-showByAuth="{ role, showCondition: ['admin'] }"
            >删除</el-button
          >
          <el-button
            link
            type="primary"
            size="small"
            @click="setFinish(row)"
            v-if="showFinishBtn(row)"
            >置为完成</el-button
          >
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      v-model:current-page="state.page.pageNum"
      v-model:page-size="state.page.pageSize"
      :page-sizes="[10, 20, 30, 40]"
      layout="total,sizes, prev, pager, next, jumper"
      :total="props.total"
    />
  </div>
</template>
<script setup>
import { storeToRefs } from 'pinia'
import { computed, reactive, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { deleteTaskReq, taskSetFinishReq } from '../api/list'
import { taskStatusMap, taskCategoryMap, orgnizationTree, taskSourceMap } from '../constant/index'
import { getLocalStore } from '../util/localStorage'
import { userLoginStore } from '../stores/login'
import { orgnizationListIdToName, orgnizationToName } from '../util/orgnization'
import { dayjs } from 'element-plus'
const authStore = userLoginStore()
const { userInfo } = storeToRefs(authStore)
const router = useRouter()
const props = defineProps({
  tableData: {
    default: [],
    type: Array
  },
  tableColumns: {
    default: [],
    type: Array
  },
  total: {
    default: 0,
    type: Number
  }
})
const emits = defineEmits(['updateTask', 'refreshList', 'changePage'])
const role = getLocalStore('userInfo').role
const userOrg = getLocalStore('userInfo').orgnization
const state = reactive({
  page: {
    pageNum: 1,
    pageSize: 10
  },
  isExpand: false
})

watch(
  () => [state.page.pageNum, state.page.pageSize],
  (val) => {
    emits('changePage', { pageNum: val[0], pageSize: val[1] })
  }
)

// 转换成状态名称
const getStatusName = computed(() => {
  return function (row) {
    if (row.status === 5) {
      let text = taskStatusMap[row.status]
      let distance = dayjs().diff(dayjs(row.finishTime), 'day')
      distance = distance > 0 ? `${distance}天` : ''
      return `${text} ${distance}`
    }
    return taskStatusMap[row.status]
  }
})

const getRowClassName = computed(() => {
  return function (row) {
    return row.row.parentId ? 'subtask-row' : 'task-row'
  }
})

// 转换成任务来源名称
const getTaskSourceName = computed(() => {
  return function (row) {
    return taskSourceMap[row.taskSource]
  }
})

// 转换成类别名称
const getCategoryName = computed(() => {
  return function (row) {
    return taskCategoryMap[row.category]
  }
})
const showFinishBtn = computed(() => {
  return function (row) {
    if (row.status === 4) {
      return false
    }
    if (role === 'admin') {
      return true
    }

    // if (row.leadOrg === userOrg) {
    //   // 责任部门可以置为完成
    //   if (row.status === 3) {
    //     return true
    //   }
    //   return false
    // }
    return false
  }
})
const getClassName = computed(() => {
  return function (row) {
    let className = ''
    switch (row.status) {
      case 1: //
        className = 'status-confirm'
        break
      case 2:
        className = 'status-adjust'
        break
      case 3:
        className = 'status-processing'
        break
      case 4:
        className = 'status-finish'
        break
      case 5:
        className = 'status-delay'
        break
      case 6:
        className = 'status-submit'
        break
      case 7:
        className = 'status-delay-process'
        break
      default:
        break
    }
    return className
  }
})
const getOrgName = computed(() => {
  return function (row, propName) {
    if (propName === 'assistOrg') {
      return orgnizationListIdToName(row[propName])
    }
    return orgnizationToName(row[propName])
  }
})

const getTime = computed(() => {
  return function (row, prop) {
    if (!row[prop]) return ''
    return dayjs(row[prop]).format('YYYY-MM-DD ')
  }
})

const updateTask = (row) => {
  emits('updateTask', row)
}
const deleteTask = async (row) => {
  const { taskId } = row
  ElMessageBox.confirm('确定要删除这项专项任务吗?', '警告', {
    type: 'warning',
    confirmButtonText: '确认',
    cancelButtonText: '取消',
    callback: async (action) => {
      if (action === 'confirm') {
        await deleteTaskReq({ taskId })
        emits('refreshList')
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
        await taskSetFinishReq(item)
        emits('refreshList')
      }
    }
  })
}

const checkTask = (row) => {
  router.push(`/supervise/detail/${row.taskId || row.parentId}`)
}
const expandAll = () => {
  state.isExpand = true
}
</script>
<style>
.status-finish {
  color: #67c23a;
}
.status-processing {
  color: #e6a23c;
}
.status-confirm {
  color: #f56c6c;
}
.status-delay {
  font-weight: bold;
  color: #f56c6c;
}
.status-adjust {
  color: #b1b3b8;
}
.status-submit {
  color: #409eff;
}
.status-delay-process {
  color: #e6a23c;
  font-weight: bold;
}
.task-content {
  /* width: 100px; */
  word-break: break-all;
  text-overflow: ellipsis;
  overflow: hidden;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 4; /* 这里是超出几行省略 */
}
.task-content-expand {
  display: block;
}
.el-pagination {
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
  align-items: center;
  margin-top: 10px;
}
.el-table .subtask-row {
  /* background-color: rgba(103, 194, 58, 0.2) !important; */
  font-size: 12px;
  color: #adadad;
}
</style>
