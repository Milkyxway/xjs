import { request } from '../request'

/**
 * 登录
 * @param {*} data
 * @returns
 */
export const loginReq = (data) => {
  return request({
    url: '/api/login',
    method: 'post',
    data
  })
}

/**
 * 登出
 * @param {*} data
 * @returns
 */
export const logoutReq = (data) => {
  return request({
    url: '/api/logout',
    method: 'post',
    data
  })
}
