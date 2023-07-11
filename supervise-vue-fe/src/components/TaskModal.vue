<template>
  <el-dialog
    :show-close="false"
    :close-on-press-escape="false"
    v-model="props.modalVisible"
    :title="props.modalType === 'add' ? '新建任务' : '修改任务'"
  >
    <el-form :model="form" ref="formRef">
      <el-form-item
        label="任务类别"
        :label-width="formLabelWidth"
        prop="category"
        :rules="rules('请选择任务类别')"
      >
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
      <el-form-item
        label="任务内容"
        :label-width="formLabelWidth"
        prop="taskContent"
        :rules="rules('请输入任务内容')"
      >
        <el-input
          :autosize="inputProps.autoSize"
          :type="inputProps.type"
          :autocomplete="inputProps.autocomplete"
          :placeholder="inputProps.placeHolder"
          v-model="form.taskContent"
        />
      </el-form-item>
      <el-form-item
        label="责任部门"
        :label-width="formLabelWidth"
        prop="leadOrg"
        :rules="rules('请选择责任部门')"
      >
        <el-select v-model="form.leadOrg" placeholder="请选择责任部门" clearable
          ><el-option
            v-for="item in orgnizationList"
            :label="item.label"
            :value="item.value"
            v-bind:key="item.key"
            >{{ item.label }}</el-option
          ></el-select
        >
      </el-form-item>
      <el-form-item
        label="协办部门"
        :label-width="formLabelWidth"
        prop="assistOrg"
        :rules="rules('请选择协办部门')"
      >
        <el-select v-model="form.assistOrg" placeholder="请选择协办部门" clearable
          ><el-option
            v-for="item in orgnizationList"
            :label="item.label"
            :value="item.value"
            v-bind:key="item.key"
            >{{ item.label }}</el-option
          ></el-select
        >
      </el-form-item>
      <!-- <el-form-item label="是否有子任务">
        <el-switch v-model="form.childTask"></el-switch>
      </el-form-item> -->
      <el-form-item label="任务目标" :label-width="formLabelWidth" prop="taskGoal">
        <el-input
          :autosize="inputProps.autoSize"
          :type="inputProps.type"
          :autocomplete="inputProps.autocomplete"
          :placeholder="inputProps.placeHolder"
          v-model="form.taskGoal"
        />
      </el-form-item>
      <el-form-item
        label="完成计划"
        :label-width="formLabelWidth"
        prop="deadline"
        :rules="rules('请选择完成计划')"
      >
        <el-date-picker></el-date-picker>
      </el-form-item>
      <!-- <el-form-item label="任务状态" :label-width="formLabelWidth" prop="status">
        <el-select v-model="form.status" placeholder="请选择"
          ><el-option
            v-for="(item, index) in taskStatus"
            v-bind:key="index"
            :label="item.label"
            :value="item.value"
            >{{ item.label }}</el-option
          ></el-select
        >
      </el-form-item> -->
      <el-form-item label="备注" :label-width="formLabelWidth" prop="comment">
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
import { reactive, ref, watch, computed } from 'vue'
import { taskStatusList, taskCategory, orgnizationTree } from '../constant/index'
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

const rules = computed(() => {
  return function (message) {
    return [
      {
        required: true,
        trigger: 'change',
        message
      }
    ]
  }
})
const formLabelWidth = '140px'

let form = reactive({
  category: '',
  taskContent: '',
  orgnization: '',
  taskGoal: '',
  status: 0,
  comment: '',
  childTask: true,
  leadOrg: '',
  assistOrg: ''
})

const formRef = ref()
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
const orgnizationList = ref(orgnizationTree)

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
  formRef.value
    .validate()
    .then((res) => {
      emit('handleCommit', form)
    })
    .catch((err) => {})
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
