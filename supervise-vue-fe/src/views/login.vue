<template>
  <div class="login-page">
    <div class="login-form">
      <el-form :model="formData" ref="loginFormRef">
        <el-form-item><div>无锡分公司专项任务督办管理平台</div></el-form-item>
        <el-form-item
          prop="username"
          :label="accountProps.label"
          :rules="[
            {
              required: true,
              message: accountProps.placeHolder,
              trigger: 'blur'
            }
          ]"
        >
          <el-input :placeholder="accountProps.placeHolder" v-model="formData.username"></el-input>
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
        <el-button type="primary" @click="login" class="login-btn">确认登录</el-button>
      </el-form>
    </div>
  </div>
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
  username: '',
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
      const result = await loginReq(formData.value)

      router.replace('/list')
    })
    .catch((err) => {
      console.log(err)
    })
}
</script>
<style scoped>
.login-page {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

.login-form {
  width: 30%;
}
.login-btn {
  width: 100%;
}
</style>
