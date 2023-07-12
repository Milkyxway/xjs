import { request } from '../request'

// 查询任务列表
export const getTaskListReq = (data) => {
  return request({
    url: '/api/task/list',
    method: 'post',
    data
  })
}

// 新建任务
export const createTaskReq = (data) => {
  return request({
    url: '/api/task/add',
    method: 'post',
    data
  })
}

/**
 * 修改任务
 * @param {*} data
 * @returns
 */
export const updateTaskReq = (data) => {
  return request({
    url: '/api/task/update',
    method: 'put',
    data
  })
}

/**
 * 删除任务
 * @param {*} data
 * @returns
 */
export const deleteTaskReq = (data) => {
  return request({
    url: '/api/task/delete',
    method: 'delete',
    data
  })
}

/**
 * 置为完成
 * @param {*} data
 * @returns
 */
export const taskSetFinishReq = (data) => {
  return request({
    url: '/api/task/finish',
    method: 'put',
    data
  })
}
