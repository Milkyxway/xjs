<template>
  <el-form :model="formData" ref="loginFormRef">
    <el-form-item
      prop="account"
      :label="accountProps.label"
      :rules="[
        {
          required: true,
          message: accountProps.placeHolder,
          trigger: 'blur'
        }
      ]"
    >
      <el-input :placeholder="accountProps.placeHolder" v-model="formData.account"></el-input>
    </el-form-item>
    <el-form-item
      prop="password"
      :label="passwordProps.label"
      :rules="[
        {
          required: true,
          message: passwordProps.placeHolder,
          trigger: 'blur'
        }
      ]"
    >
      <el-input :placeholder="passwordProps.placeHolder" v-model="formData.password"></el-input>
    </el-form-item>
    <el-button type="primary" @click="login">确认登录</el-button>
  </el-form>
</template>
<script setup>
import { ref } from 'vue'
import { storeToRefs } from 'pinia'
import { loginReq } from '../api/login'
import router from '../router'
import { userLoginStore } from '../stores/login'
const authStore = userLoginStore()
const { userInfo } = storeToRefs(authStore)
const { loginFn, setUserInfo } = authStore
const loginFormRef = ref()
const formData = ref({
  account: '',
  password: ''
})
const accountProps = ref({
  placeHolder: '请输入账号',
  clearable: true,
  label: '账号',
  required: true
})
const passwordProps = ref({
  placeHolder: '请输入密码',
  type: 'password',
  clearable: true,
  label: '密码',
  required: true
})

const login = () => {
  loginFormRef.value
    .validate()
    .then(async (res) => {
      // const result = await loginReq(formData)
      // loginFn(result.data.data)
      setUserInfo(formData)
      router.replace('/list')
    })
    .catch((err) => {
      console.log(err)
    })
}
</script>
<style scoped></style>
