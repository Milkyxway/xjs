<template>
  <el-dialog
    :show-close="false"
    :close-on-press-escape="false"
    v-model="props.modalVisible"
    :title="getModalTitle"
  >
    <el-form :model="form" ref="formRef">
      <el-form-item
        label="任务类别"
        :label-width="formLabelWidth"
        prop="category"
        :rules="rules('请选择任务类别')"
      >
        <el-select v-model="form.category" placeholder="请选择" :disabled="disableCondition"
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
          :disabled="disableCondition"
        />
      </el-form-item>
      <el-form-item
        label="责任部门"
        :label-width="formLabelWidth"
        prop="leadOrg"
        :rules="rules('请选择责任部门')"
      >
        <el-select
          v-model="form.leadOrg"
          placeholder="请选择责任部门"
          clearable
          :disabled="disableCondition"
          ><el-option
            v-for="item in orgnizationList"
            :label="item.label"
            :value="item.value"
            v-bind:key="item.key"
            >{{ item.label }}</el-option
          ></el-select
        >
      </el-form-item>
      <el-form-item label="协办部门" :label-width="formLabelWidth" prop="assistOrg">
        <el-select
          v-model="form.assistOrg"
          placeholder="请选择协办部门"
          clearable
          multiple
          :disabled="disableCondition"
          ><el-option
            v-for="item in orgnizationList"
            :label="item.label"
            :value="item.value"
            v-bind:key="item.key"
            >{{ item.label }}</el-option
          ></el-select
        >
      </el-form-item>

      <!-- <el-form-item label="任务目标" :label-width="formLabelWidth" prop="taskGoal">
        <el-input
          :autosize="inputProps.autoSize"
          :type="inputProps.type"
          :autocomplete="inputProps.autocomplete"
          :placeholder="inputProps.placeHolder"
          v-model="form.taskGoal"
        />
      </el-form-item> -->
      <!-- <el-form-item
        label="完成计划"
        :label-width="formLabelWidth"
        prop="deadline"
        :rules="rules('请选择完成计划')"
      >
        <el-date-picker></el-date-picker>
      </el-form-item> -->
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
      <!-- <el-form-item
        label="调整类型"
        :label-width="formLabelWidth"
        prop="appealType"
        v-if="modalType === 'appeal'"
        :rules="[{ required: modalType === 'appeal', message: '请选择调整类型' }]"
      >
        <el-select placeholder="请选择调整类型" v-model="form.appealType">
          <el-option
            v-for="item in appealCategory"
            :label="item.label"
            :value="item.value"
            v-bind:key="item.key"
            >{{ item.label }}</el-option
          >
        </el-select>
      </el-form-item> -->
      <el-form-item
        label="备注"
        :label-width="formLabelWidth"
        prop="comment"
        :rules="[{ required: modalType === 'appeal', message: '请输入调整内容' }]"
      >
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
import { taskStatusList, taskCategory, orgnizationTree, appealCategory } from '../constant/index'
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
  // appealType: null
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

const getModalTitle = computed(() => {
  let title = ''
  switch (props.modalType) {
    case 'add':
      title = '创建任务'
      break
    case 'update':
      title = '修改任务'
      break
    case 'appeal':
      title = '调整任务'
      break
    default:
      break
  }
  return title
})
const disableCondition = computed(() => {
  return props.modalType === 'appeal'
})
const handleCancel = () => {
  emit('handleCancel')
}
const handleCommit = () => {
  formRef.value
    .validate()
    .then((res) => {
      emit('handleCommit', {
        ...form,
        assistOrg: form.assistOrg ? form.assistOrg.join(',') : ''
      })
    })
    .catch((err) => {
      console.log(err)
    })
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
