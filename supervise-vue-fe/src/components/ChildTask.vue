<template>
  <div class="child-task-row">
    <div>
      <div class="child-task-row">
        <span class="paddingLR10">计划完成目标</span>
        <el-input
          v-model="props.data.taskGoal"
          placeholder="请填写子任务目标"
          :disabled="props.taskStatus > 2"
          type="textarea"
          rows="3"
        ></el-input>
      </div>
      <div class="child-task-row">
        <span class="paddingLR10">计划完成时间</span>
        <el-date-picker
          v-model="props.data.finishTime"
          placeholder="请选择子任务计划完成时间"
          :disabled="[3, 7, 6].includes(props.taskStatus)"
        ></el-date-picker>
      </div>
      <div class="child-task-row" v-if="props.taskStatus == 5">
        <span class="paddingLR10">延期说明</span>
        <el-input
          placeholder="请填写子任务延期说明"
          v-model="props.data.delayReason"
          type="textarea"
          rows="3"
        ></el-input>
      </div>
      <div class="child-task-row" v-if="[3, 7].includes(props.taskStatus)">
        <span class="paddingLR10">实际完成时间</span>
        <el-date-picker
          placeholder="请选择子任务实际完成时间"
          v-model="props.data.actualFinish"
        ></el-date-picker>
      </div>
      <div class="child-task-row" v-if="[3, 7].includes(props.taskStatus)">
        <span class="paddingLR10">完成情况说明</span>
        <el-input
          placeholder="请填写子任务完成情况说明"
          v-model="props.data.completeDesc"
          type="textarea"
          rows="3"
        ></el-input>
      </div>
      <div v-if="state.fileLink" class="child-task-row">
        <span>附件：</span>
        <span class="submit-btn mr10" @click="downloadUrl(state.fileLink)">{{
          state.fileLink
        }}</span>
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
import { reactive } from 'vue'
import Upload from './Upload.vue'
import { updateSubtaskReq, deleteFileReq } from '../api/list'
import { toast } from '../util/toast'
import { commonFileUpload, downloadUrl } from '../util/link'
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
const emits = defineEmits(['addChild', 'deleteChild', 'handleItemSubmit'])

const addChild = () => {
  emits('addChild')
}

const deleteChild = () => {
  emits('deleteChild')
}

const handleItemSubmit = () => {
  emits('handleItemSubmit', { ...props.data, fileLink: state.fileLink || props.data.fileLink })
}

const handleFileChange = async (file) => {
  const fileLink = await commonFileUpload(file)
  toast('上传附件成功！')
  commonDeal(fileLink)
}

const deleteFile = async () => {
  const { fileLink } = state
  const fileLinkSplit = fileLink.split('/upload/')
  await deleteFileReq({
    fileName: fileLinkSplit[1],
    path: 'upload'
  })
  toast('删除附件成功！')
  commonDeal('')
}

const commonDeal = async (fileLink) => {
  await updateSubtaskReq({
    subtaskId: props.data.subtaskId,
    fileLink,
    parentId: props.data.parentId,
    status: props.data.status
  })
  state.fileLink = fileLink
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
