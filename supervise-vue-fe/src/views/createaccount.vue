<template>
  <el-card>
    <template #header>
      <div class="card-header">
        <span>创建账号</span>
      </div>
    </template>
    <el-form ref="formRef" :model="state.formData">
      <el-form-item
        :label-width="formLabelWidth"
        label="用户名"
        prop="username"
        :rules="[{ required: true, message: '请输入用户名', trigger: 'blur' }]"
      >
        <el-input v-model="state.formData.username"></el-input>
      </el-form-item>
      <el-form-item
        :label-width="formLabelWidth"
        label="密码"
        prop="password"
        :rules="[{ required: true, message: '请输入密码', trigger: 'blur' }]"
      >
        <el-input v-model="state.formData.password" type="password"></el-input>
      </el-form-item>
      <el-form-item :label-width="formLabelWidth" label="用户名中文">
        <el-input v-model="state.formData.usernameCn"></el-input>
      </el-form-item>
      <el-form-item label="角色" prop="role" :label-width="formLabelWidth">
        <el-radio-group v-model="state.formData.role">
          <el-radio
            v-for="(item, index) in roleList"
            :label="item.label"
            :name="item.name"
            v-bind:key="index"
            >{{ item.label }}</el-radio
          >
        </el-radio-group>
      </el-form-item>
      <el-form-item
        label="部门"
        prop="orgnization"
        :label-width="formLabelWidth"
        v-if="state.formData.role === '部门'"
      >
        <SelectCommon
          v-model:select="state.formData.orgnization"
          :selections="sectionList"
          @updateSelect="
            (val) => {
              if (val !== '') {
                state.formData.orgnization = val
              }
            }
          "
        ></SelectCommon>
      </el-form-item>
    </el-form>
    <el-button type="primary" @click="handleSubmit">提交</el-button>
  </el-card>
</template>
<script setup>
import { reactive, ref } from 'vue'
import { storeToRefs } from 'pinia'
import { sectionStore } from '../stores/orgList'
import { createAccountReq } from '../api/login'
import { toast } from '../util/toast'
import { getLocalStore } from '../util/localStorage'
import SelectCommon from '../components/SelectCommon.vue'
const region = ref(getLocalStore('userInfo').region)
const state = reactive({
  formData: {
    username: '',
    password: '',
    role: '部门',
    usernameCn: '',
    orgnization: ''
  }
})
const formRef = ref()
const setionStore = sectionStore()
const { sectionList } = storeToRefs(setionStore)
const formLabelWidth = '140px'
const roleList = [
  {
    label: '管理员',
    value: 'admin'
  },
  {
    label: '领导',
    value: 'leader'
  },
  {
    label: '分管领导',
    value: 'sub-leader'
  },
  {
    label: '部门',
    value: 'section'
  },
  {
    label: '员工',
    value: 'employee'
  }
]
const handleSubmit = () => {
  formRef.value.validate(async (res) => {
    await createAccountReq({
      ...state.formData,
      role: roleList.filter((i) => i.label === state.formData.role)[0].value,
      region: region.value,
      orgnization: state.formData.role === '部门' ? state.formData.orgnization : null
    })
    toast()
  })
}
const init = async () => {
  await setionStore.getOrgList()
}
init()
</script>
