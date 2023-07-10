import { request } from '../request'

// 查询任务列表
export const getTaskListReq = (params) => {
  return request({
    url: '/api/task/list',
    method: 'get',
    params
  })
}

// 新建任务
export const createTaskReq = (params) => {
  return request({
    url: '/api/task/add',
    method: 'post',
    params
  })
}

// 修改任务
export const updateTaskReq = (params) => {
  return request({
    url: '/api/task/update',
    method: 'put',
    params
  })
}

// 删除任务
export const deleteTaskReq = (params) => {
  return request({
    url: '/api/task/delete',
    method: 'delete',
    params
  })
}
