<template>
  <div class="login-page">
    <div class="login-form">
      <el-form :model="formData" ref="loginFormRef">
        <el-form-item><div class="title">无锡分公司专项任务督办管理平台</div></el-form-item>
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
          <el-input
            :placeholder="passwordProps.placeHolder"
            v-model="formData.password"
            type="password"
          ></el-input>
        </el-form-item>
        <el-button type="primary" @click="login" class="login-btn">确认登录</el-button>
      </el-form>
    </div>
  </div>
</template>
<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { storeToRefs } from 'pinia'
import { loginReq } from '../api/login'

import { setLocalStore } from '../util/localStorage'
import { userLoginStore } from '../stores/login'
const authStore = userLoginStore()
const { userInfo } = storeToRefs(authStore)
const { loginFn, setUserInfo } = authStore
const loginFormRef = ref()
const formData = ref({
  username: '',
  password: ''
})
const router = useRouter()
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
      setLocalStore('userInfo', result.data.userInfo)
      router.replace('/supervise/list')
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
  width: 100%;
  background-image: url('../assets/bg.jpg');
  background-repeat: repeat;
}

.login-form {
  width: 30%;
  background: #fff;
  height: auto;
  border-radius: 8px;
  padding: 20px;
}
.title {
  color: #cecece;
  font-weight: bold;
  font-size: 28px;
}
.login-btn {
  width: 100%;
}
</style>
