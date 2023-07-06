import { request } from '../request'

// 查询任务列表
export const getTaskListReq = (params) => {
  return request({
    url: '/market/api/file/upload/access',
    method: 'get',
    params
  })
}

// 新建任务
export const createTaskReq = (params) => {
  return request({
    url: '/market/api/file/upload/access',
    method: 'get',
    params
  })
}

// 修改任务
export const updateTaskReq = (params) => {
  return request({
    url: '/market/api/file/upload/access',
    method: 'get',
    params
  })
}

// 删除任务
export const deleteTaskReq = (params) => {
  return request({
    url: '/market/api/file/upload/access',
    method: 'get',
    params
  })
}
