<template>
  <div class="login-page">
    <div class="left">
      <div class="name-box"></div>
      <div class="pro-name">无锡分公司专项任务督办平台</div>
    </div>
    <div class="right">
      <div class="login-form">
        <div class="welcome">欢迎登录！</div>
        <el-form :model="formData" ref="loginFormRef">
          <el-form-item><div class="title"></div></el-form-item>
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
            <el-input
              :placeholder="accountProps.placeHolder"
              v-model="formData.username"
            ></el-input>
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
            ></el-input>
          </el-form-item>
          <el-button type="primary" @click="login" class="login-btn">确认登录</el-button>
        </el-form>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { storeToRefs } from 'pinia'
import { loginReq } from '../api/login'

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
      // console.log(err)
    })
}

const redirect = () => {
  const userInfo = getLocalStore('userInfo')
  if (userInfo && userInfo.role) {
    router.replace('/supervise/list')
  }
}
redirect()
</script>
<style scoped>
.login-page {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: center;
  height: 100vh;
  width: 100%;
  /* background-image: url('../assets/bg.jpg'); */
  /* background-repeat: repeat; */
}
@keyframes moveBottomTop {
  0% {
    top: 100%;
  }
  /* 50% {
    top: 50%;
  } */
  100% {
    top: 0;
  }
}
@keyframes moveTopBottom {
  0% {
    top: 0;
  }
  /* 50% {
    top: 50%;
  } */
  100% {
    top: 100%;
  }
}
.left {
  width: 50%;
  height: 100vh;
  position: relative;

  animation-name: moveBottomTop;
  animation-duration: 0.5s;
  animation-iteration-count: 1;

  /* transform: translate(50px, 0); */
}
.name-box {
  height: 0;
  width: 100%;
  border-top: 100vh solid #015cac;
  border-right: 100px solid transparent;
}
.pro-name {
  color: #fff;
  font-weight: bold;
  position: absolute;
  top: 50%;
  left: 20%;
  font-size: 32px;
}
.right {
  width: 50%;
  height: 100vh;
  animation-name: moveTopBottom;
  animation-duration: 0.5s;
  animation-iteration-count: 1;
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
}
.login-form {
  width: 70%;
  background: #fff;
  height: auto;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0px 0px 20px 0px rgba(0, 0, 0, 0.3);
}
.welcome {
  color: #bbb;
  font-size: 30px;
  font-weight: bold;
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
