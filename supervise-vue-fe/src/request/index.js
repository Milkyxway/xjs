import axios from 'axios'
import router from '../router'
import { toast } from '../util/toast'
export const request = createRequest()
function createRequest() {
  const request = axios.create({
    baseURL: `http://127.0.0.1:7001`,
    headers: {
      common: {
        ['Cache-Control']: 'no-cache'
        // ["Authorization"]: defaultEmptyParam([authorization.value]),
      },
      post: {
        // ['Content-Type']: 'application/x-www-form-urlencoded'
      }
    }
  })

  // request拦截
  request.interceptors.request.use(
    (config) => {
      // 某些接口不允许携带 Authorization
      if (config.authorization === false) {
        config.headers.common['Authorization'] = ''
      }
      return config
    },
    (error) => {
      console.log(error)
      Promise.reject(error)
    }
  )

  // response拦截
  request.interceptors.response.use(
    (res) => {
      const { code, msg } = res.data

      if (code === 200) {
        return res.data
      } else if (code === 401) {
        router.replace('/login')
      } else {
        toast(msg, 'error')
        return Promise.reject(msg || '网络错误')
      }
    },
    (err) => {
      toast(err.msg || '网络错误', 'error')
      return Promise.reject(err)
    }
  )

  return request
}

function setRequestCommonHeaders(key, value) {
  request.defaults.headers.common[key] = value
}

export const setAuthorization = function (authorization) {
  setRequestCommonHeaders('Authorization', authorization)
}

export const setToken = function (token) {
  setRequestCommonHeaders('token', token)
}

export const setOpenId = function (openid) {
  setRequestCommonHeaders('jf-openid', openid)
}

export const setSign = function (data) {
  setRequestCommonHeaders('verification', data.verification) // 校验方式(固定值 signature)
  setRequestCommonHeaders('version', data.version) // 当前app版本号
  setRequestCommonHeaders('reqTs', data.reqTs) // 当前时间戳，毫秒
  setRequestCommonHeaders('reqNonc', data.reqNonc) // 随机数
  setRequestCommonHeaders('reqSign', data.reqSign) // 签名md5值
}
