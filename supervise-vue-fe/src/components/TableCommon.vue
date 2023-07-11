<template>
  <el-table :data="props.tableData">
    <el-table-column
      v-for="item in props.tableColumns"
      :label="item.columnName"
      :prop="item.prop"
      :key="item.key"
    >
      <template #default="{ row }">
        <span v-if="item.prop === 'status'" :class="getClassName(row)">{{
          getStatusName(row)
        }}</span>
        <span v-if="item.prop === 'category'">{{ getCategoryName(row) }}</span>
      </template></el-table-column
    >

    <el-table-column fixed="right" label="操作" width="120">
      <template #default="{ row }">
        <el-button link type="primary" size="small" @click="updateTask(row)">修改</el-button>
        <el-button link type="primary" size="small" @click="deleteTask(row)">删除</el-button>
        <el-button link type="primary" size="small" @click="setFinish(row)">置为完成</el-button>
      </template>
    </el-table-column>
  </el-table>
</template>
<script setup>
import { computed } from 'vue'
import { taskStatusMap, taskCategoryMap } from '../constant/index'
const props = defineProps({
  tableData: {
    default: [],
    type: Array
  },
  tableColumns: {
    default: [],
    type: Array
  }
})
const emits = defineEmits(['updateTask', 'deleteTask', 'setFinish'])

// 转换成状态名称
const getStatusName = computed(() => {
  return function (row) {
    return taskStatusMap[row.status]
  }
})

// 转换成类别名称
const getCategoryName = computed(() => {
  return function (row) {
    return taskCategoryMap[row.category]
  }
})

const getClassName = computed(() => {
  return function (row) {
    let className = ''
    switch (row.status) {
      case 1:
        className = 'status-finish'
        break
      case 2:
        className = 'status-pending'
        break
      default:
        break
    }
    return className
  }
})
const updateTask = (row) => {
  emits('updateTask', row)
}
const deleteTask = (row) => {
  emits('deleteTask', row)
}
const setFinish = (row) => {
  emits('setFinish', row)
}
</script>
<style scoped>
.status-finish {
  color: #67c23a;
}
.status-pending {
  color: #e6a23c;
}
</style>
