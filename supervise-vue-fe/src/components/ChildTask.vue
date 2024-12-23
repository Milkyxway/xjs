<template>
  <div class="child-task-row">
    <div>
      <div class="child-task-row">
        <span class="paddingLR10">计划完成目标</span>
        <el-input
          v-model="props.data.taskGoal"
          placeholder="请填写计划完成目标"
          :disabled="props.taskStatus > 2"
          type="textarea"
          rows="3"
        ></el-input>
      </div>
      <div class="child-task-row">
        <span class="paddingLR10">计划完成时间</span>
        <el-date-picker
          v-model="props.data.finishTime"
          placeholder="请选择计划完成时间"
          :disabled="[3, 7, 6].includes(props.taskStatus)"
        ></el-date-picker>
      </div>
      <div class="child-task-row" v-if="props.taskStatus == 5">
        <span class="paddingLR10">延期说明</span>
        <el-input
          placeholder="请填写延期说明"
          v-model="props.data.delayReason"
          type="textarea"
          rows="3"
        ></el-input>
      </div>
      <div class="child-task-row" v-if="[3, 7].includes(props.taskStatus)">
        <span class="paddingLR10">实际完成时间</span>
        <el-date-picker
          placeholder="请选择实际完成时间"
          v-model="props.data.actualFinish"
        ></el-date-picker>
      </div>
      <div class="child-task-row" v-if="[3, 7].includes(props.taskStatus)">
        <span class="paddingLR10">完成情况说明</span>
        <el-input
          placeholder="请填写完成情况说明"
          v-model="props.data.completeDesc"
          type="textarea"
          rows="3"
        ></el-input>
      </div>
      <div v-if="state.fileLink" class="child-task-row">
        <span>附件：</span>
        <span class="submit-btn mr10" @click="downloadFile">{{ state.fileLink }}</span>
        <el-icon @click="deleteFile(index)"><Delete /></el-icon>
      </div>
    </div>
    <div class="op-box">
      <el-icon color="#0076fe" @click="addChild" v-if="props.isFirst">
        <CirclePlus v-if="props.fatherStatus == 1" />
      </el-icon>
      <el-icon @click="deleteChild(index)" v-if="!props.isFirst"
        ><Delete v-if="props.fatherStatus == 1"
      /></el-icon>
      <Upload
        v-if="[3, 7].includes(props.taskStatus)"
        btnTxt="添加完成结果附件"
        @handleChange="handleFileChange"
      />
      <div v-if="[3, 5, 7].includes(props.taskStatus)" @click="handleItemSubmit" class="submit-btn">
        提交
      </div>
    </div>
  </div>
</template>
<script setup>
import dayjs from 'dayjs'
import Upload from './Upload.vue'
import { updateSubtaskReq, uploadReq, deleteFileReq } from '../api/list'
import { toast } from '../util/toast'
import { reactive } from 'vue'
const props = defineProps({
  data: {
    type: Object,
    default: {}
  },
  isFirst: {
    type: Boolean,
    default: true
  },
  taskStatus: {
    type: Number,
    default: 0
  },
  fatherStatus: {
    type: Number,
    default: 0
  }
})

const state = reactive({
  fileLink: props.data.fileLink
})
console.log(props.data)
const emits = defineEmits(['addChild', 'deleteChild', 'handleItemSubmit'])

const addChild = () => {
  emits('addChild')
}

const deleteChild = () => {
  emits('deleteChild')
}

const handleItemSubmit = () => {
  emits('handleItemSubmit', props.data)
}

const handleFileChange = async (file) => {
  const now = dayjs().format('YYYYMMDDHHmmss')
  const fileSplitLength = file.name.split('.').length
  const fileSuffix = file.name.split('.')[fileSplitLength - 1]
  const fileOriginName = file.name.split('.')[0]
  const newFile = `${fileOriginName}${now}.${fileSuffix}`
  const copyFile = new File([file], `${newFile}`)
  const formData = new FormData()
  formData.append('file', copyFile)
  await uploadReq(formData)
  toast('上传附件成功！')
  const fileLink = `http://172.16.179.5:7001/public/upload/${fileOriginName}${now}.${fileSuffix}`
  await updateSubtaskReq({
    subtaskId: props.data.subtaskId,
    fileLink,
    parentId: props.data.parentId,
    status: props.data.status
  })
  state.fileLink = fileLink
}

const deleteFile = async () => {
  const { fileLink } = state
  const fileLinkSplit = fileLink.split('/upload/')
  await deleteFileReq({
    fileName: fileLinkSplit[1],
    path: 'upload'
  })
  toast('删除附件成功！')
  await updateSubtaskReq({
    subtaskId: props.data.subtaskId,
    fileLink: '',
    parentId: props.data.parentId,
    status: props.data.status
  })
  state.fileLink = ''
}

const downloadFile = () => {
  window.location.href = state.fileLink
}
</script>
<style scoped>
.child-task-row {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: center;
  white-space: nowrap;
  width: 800px;
  margin-bottom: 6px;
}
.paddingLR10 {
  padding: 0 10px 10px 0;
}
.submit-btn {
  color: #0076fe;
  cursor: pointer;
}
:deep(.el-date-editor) {
  width: 800px !important;
}
.op-box {
  margin-left: 20px;
}
.mr10 {
  margin-right: 30px;
}
</style>
