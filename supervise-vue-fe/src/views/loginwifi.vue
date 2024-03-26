<template>
  <div class="login-page">
    <img src="../assets/loginbg.png" class="login-bg" />
    <div class="login-form">
      <el-form :model="formData" ref="loginFormRef">
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
            :show-password="true"
          >
            <template #suffix>
              <span
                @click="getSmsCode"
                :style="smsTxt === '获取验证码' ? { color: '#0076fe' } : { color: '#cecece' }"
                >{{ smsTxt }}</span
              >
            </template>
          </el-input>
        </el-form-item>
        <div class="btn-wrap">
          <el-button type="primary" @click="login" class="login-btn">确认登录</el-button>
        </div>
      </el-form>
    </div>
  </div>
</template>
<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { storeToRefs } from 'pinia'
import { loginReq, getSmsCodeReq } from '../api/login'

import { getLocalStore, setLocalStore } from '../util/localStorage'
import { userLoginStore } from '../stores/login'
const authStore = userLoginStore()
const { userInfo } = storeToRefs(authStore)
const { loginFn, setUserInfo } = authStore
const loginFormRef = ref()
const formData = ref({
  username: '',
  password: ''
})
const waiting = ref(false)
const router = useRouter()
const accountProps = ref({
  placeHolder: '请输入手机号',
  clearable: true,
  label: '手机号',
  required: true
})
const passwordProps = ref({
  placeHolder: '请输入验证码',
  type: 'password',
  clearable: true,
  label: '验证码',
  required: true
})
const countdown = ref(60)
const smsTxt = ref('获取验证码')

const login = () => {
  loginFormRef.value
    .validate()
    .then(async (res) => {
      const result = await loginReq(formData.value)
      setLocalStore('userInfo', result.data.userInfo)
      // router.replace('/report/list')
      router.replace('/supervise/list')
    })
    .catch((err) => {
      // console.log(err)
    })
}

const getSmsCode = () => {
  if (smsTxt.value !== '获取验证码') {
    return
  }
  const timer = setInterval(() => {
    if (countdown.value > 0) {
      countdown.value--
      smsTxt.value = `${countdown.value}s后重发`
    } else {
      clearInterval(timer)
      smsTxt.value = '获取验证码'
    }
  }, 1000)
}
const redirect = () => {
  const userInfo = getLocalStore('userInfo')
  if (userInfo && userInfo.role) {
    // router.replace('/report/list')
    router.replace('/supervise/list')
  }
}
// redirect()
</script>
<style scoped>
.login-page {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: flex-start;
  height: 100vh;
  width: 100%;
  font-size: 32px;
  /* position: relative; */
  /* background-image: url('../assets/loginbg.png');
    background-repeat: no-repeat;
    background-size: contain; */
}
.login-bg {
  width: 100%;
  height: auto;
}

.login-form {
  width: 336px;
  position: absolute;
  top: 360px;
  left: 860px;
}
.title {
  color: #cecece;
  font-weight: bold;
  font-size: 28px;
}
.btn-wrap {
  width: 100%;
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
}
.login-btn {
  width: 10.5rem;
  height: 2rem;
  background-color: #0076fe;
  border-radius: 37px;
  margin-top: 4rem;
  color: #fff;
  font-weight: bold;
  text-align: center;
  line-height: 2rem;
}
</style>
