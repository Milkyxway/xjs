import { request } from '../request'

export const getTaskListReq = (params) => {
  return request({
    url: '/market/api/file/upload/access',
    method: 'get',
    params
  })
}
