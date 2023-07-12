<template>
  <div>
    <div>
      <span>任务类别</span><span>{{ taskDetail?.category }}</span>
    </div>
    <div>
      <span>任务内容</span><span>{{ taskDetail.taskContent }}</span>
    </div>
    <div>
      <span>责任部门</span><span>{{ taskDetail.leadOrg }}</span>
    </div>
    <div>
      <span>协办部门</span><span>{{ taskDetail.assistOrg }}</span>
    </div>
  </div>
</template>
<script setup>
import { reactive, computed } from 'vue'
// import { useRouteQuery } from '@vueuse/router'
import { taskDetailReq } from '../api/list'
import { orgnizationListIdToName, orgnizationToName } from '../util/orgnization'
import { taskCategoryMap } from '../constant/index'
// const taskId = useRouteQuery('taskId')
let taskDetail = reactive({})
// const getTaskCatefory = computed(() => {
//   return function (category) {
//     return taskCategoryMap[category]
//   }
// })
const getTaskDetail = async () => {
  const result = await taskDetailReq({ taskId: 31 })
  const {
    data: { taskContent, category, leadOrg }
  } = result
  taskDetail.taskContent = taskContent
  taskDetail.category = taskCategoryMap[category]
  taskDetail.leadOrg = orgnizationToName(leadOrg)
  taskDetail.assistOrg = orgnizationListIdToName(result.data.assistOrg)
}

getTaskDetail()
</script>
<style></style>
