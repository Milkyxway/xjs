import { createRequest } from '../request'

// 查询任务列表
export const getTaskListReq = (data) => {
  return createRequest()({
    url: '/api/task/list',
    method: 'post',
    data
  })
}

/**
 * 查询我的任务
 * @param {*} data
 * @returns
 */
export const myTaskReq = (data) => {
  return createRequest()({
    url: '/api/task/mine',
    method: 'post',
    data
  })
}

// 新建任务
export const createTaskReq = (data) => {
  return createRequest()({
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
  return createRequest()({
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
  return createRequest()({
    url: '/api/task/delete',
    method: 'delete',
    data
  })
}

/**
 * 增加阶段任务
 * @param {*} data
 * @returns
 */
export const addSubTaskReq = (data) => {
  return createRequest()({
    url: '/api/subtask/add',
    method: 'post',
    data
  })
}

/**
 * 修改阶段任务
 * @param {*} data
 * @returns
 */
export const updateSubtaskReq = (data) => {
  return createRequest()({
    url: '/api/subtask/update',
    method: 'post',
    data
  })
}

/**
 * 置为完成
 * @param {*} data
 * @returns
 */
export const taskSetFinishReq = (data) => {
  return createRequest()({
    url: '/api/task/finish',
    method: 'put',
    data
  })
}

/**
 * 查询任务详情
 * @param {*} data
 * @returns
 */
export const taskDetailReq = (data) => {
  return createRequest()({
    url: '/api/task/detail',
    method: 'post',
    data
  })
}

/**
 * 对任务调整
 * @param {*} data
 * @returns
 */
export const appealTaskReq = (data) => {
  return createRequest()({
    url: '/api/task/appeal',
    method: 'post',
    data
  })
}
