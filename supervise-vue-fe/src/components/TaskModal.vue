<template>
  <el-dialog
    :show-close="false"
    :close-on-press-escape="false"
    v-model="props.modalVisible"
    :title="props.modalType === 'add' ? '新建任务' : '修改任务'"
  >
    <el-form :model="form">
      <el-form-item label="任务类别" :label-width="formLabelWidth">
        <el-select v-model="form.category" placeholder="请选择"
          ><el-option
            v-for="(item, index) in taskCategoryList"
            v-bind:key="index"
            :label="item.label"
            :value="item.value"
            >{{ item.label }}</el-option
          ></el-select
        >
      </el-form-item>
      <el-form-item label="任务内容" :label-width="formLabelWidth">
        <el-input
          :autosize="inputProps.autoSize"
          :type="inputProps.type"
          :autocomplete="inputProps.autocomplete"
          :placeholder="inputProps.placeHolder"
          v-model="form.taskContent"
        />
      </el-form-item>
      <el-form-item label="组织架构" :label-width="formLabelWidth">
        <el-input v-model="form.orgnization" autocomplete="off" />
      </el-form-item>
      <el-form-item label="任务目标" :label-width="formLabelWidth">
        <el-input
          :autosize="inputProps.autoSize"
          :type="inputProps.type"
          :autocomplete="inputProps.autocomplete"
          :placeholder="inputProps.placeHolder"
          v-model="form.taskGoal"
        />
      </el-form-item>
      <el-form-item label="任务状态" :label-width="formLabelWidth">
        <el-select v-model="form.status" placeholder="请选择"
          ><el-option
            v-for="(item, index) in taskStatus"
            v-bind:key="index"
            :label="item.label"
            :value="item.value"
            >{{ item.label }}</el-option
          ></el-select
        >
      </el-form-item>
      <el-form-item label="备注" :label-width="formLabelWidth">
        <el-input
          :autosize="inputProps.autoSize"
          :type="inputProps.type"
          :autocomplete="inputProps.autocomplete"
          :placeholder="inputProps.placeHolder"
          v-model="form.comment"
        />
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

<script setup>
import { reactive, ref, watch } from 'vue'
import { taskStatusList, taskCategory } from '../constant/index'
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
  category: '',
  taskContent: '',
  orgnization: '',
  taskGoal: '',
  status: '',
  comment: ''
})
const inputProps = ref({
  placeHolder: '请输入',
  type: 'textarea',
  autoSize: {
    minRows: 2,
    maxRows: 6
  },
  autocomplete: false
})
const taskStatus = ref(taskStatusList)
const taskCategoryList = ref(taskCategory)

watch(
  () => props.formData,
  (val) => (form = val),
  {
    immediate: true
  }
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
