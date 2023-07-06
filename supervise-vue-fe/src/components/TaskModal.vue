<template>
  <!-- Form -->

  <el-dialog
    v-model="props.modalVisible"
    :title="props.modalType === 'add' ? '新建任务' : '修改任务'"
  >
    <el-form :model="form">
      <el-form-item label="任务类别" :label-width="formLabelWidth">
        <el-input v-model="form.category" autocomplete="off" />
      </el-form-item>
      <el-form-item label="任务内容" :label-width="formLabelWidth">
        <el-input v-model="form.taskContent" autocomplete="off" />
      </el-form-item>
      <el-form-item label="组织架构" :label-width="formLabelWidth">
        <el-input v-model="form.orgnization" autocomplete="off" />
      </el-form-item>
      <el-form-item label="任务目标" :label-width="formLabelWidth">
        <el-input v-model="form.taskGoal" autocomplete="off" />
      </el-form-item>
      <el-form-item label="任务状态" :label-width="formLabelWidth">
        <el-select v-model="form.status"></el-select>
      </el-form-item>
      <el-form-item label="备注" :label-width="formLabelWidth">
        <el-input :autosize="{ minRows: 2, maxRows: 4 }" type="textarea" v-model="form.comment" />
      </el-form-item>
    </el-form>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="handleCancel">取消</el-button>
        <el-button type="primary" @click="handleCommit"> 确定 </el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
const props = defineProps({
  modalVisible: {
    default: false,
    type: Boolean
  },
  modalType: {
    default: '',
    type: String
  },
  formData: {
    default: {},
    type: Object
  }
})

const emit = defineEmits(['handleCancel', 'handleCommit'])
const formLabelWidth = '140px'

let form = reactive({
  name: '',
  category: '',
  taskContent: '',
  orgnization: '',
  taskGoal: '',
  status: '',
  comment: ''
})

const gridData = [
  {
    date: '2016-05-02',
    name: 'John Smith',
    address: 'No.1518,  Jinshajiang Road, Putuo District'
  },
  {
    date: '2016-05-04',
    name: 'John Smith',
    address: 'No.1518,  Jinshajiang Road, Putuo District'
  },
  {
    date: '2016-05-01',
    name: 'John Smith',
    address: 'No.1518,  Jinshajiang Road, Putuo District'
  },
  {
    date: '2016-05-03',
    name: 'John Smith',
    address: 'No.1518,  Jinshajiang Road, Putuo District'
  }
]
watch(
  () => props.formData,
  (val) => (form = val)
)

const handleCancel = () => {
  emit('handleCancel')
}
const handleCommit = () => {
  emit('handleCommit', form)
}
</script>
<style scoped>
.el-button--text {
  margin-right: 15px;
}
.el-select {
  width: 300px;
}
.el-input {
  width: 300px;
}
.dialog-footer button:first-child {
  margin-right: 10px;
}
</style>
