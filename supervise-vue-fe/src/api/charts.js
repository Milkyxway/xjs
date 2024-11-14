import { createRequest } from '../request'

export const getPieChartReq = (data) => {
  return createRequest()({
    url: '/api/chart/pie',
    method: 'post',
    data
  })
}

export const getSectionTaskSortReq = (data) => {
  return createRequest()({
    url: '/api/chart/sort',
    method: 'post',
    data
  })
}

export const getFinishProcessReq = (data) => {
  return createRequest()({
    url: '/api/chart/finishprocess',
    method: 'post',
    data
  })
}

/**
 * 按条件查找任务总数
 * @param {*} data
 * @returns
 */
export const getTotalTaskReq = (data) => {
  return createRequest()({
    url: '/api/chart/totaltasks',
    method: 'post',
    data
  })
}

/**
 * 任务完成比例按部门排序
 * @param {*} data
 * @returns
 */
export const getFinishRateReq = (data) => {
  return createRequest()({
    url: '/api/chart/finishrate',
    method: 'post',
    data
  })
}

/**
 * 获取各个任务状态占比
 * @param {*} data
 * @returns
 */
export const getStatusProportionReq = (data) => {
  return createRequest()({
    url: '/api/chart/statusProportion',
    method: 'post',
    data
  })
}

/**
 * 获取本月新增任务
 * @param {*} data
 * @returns
 */
export const getNewTaskInMonthReq = (data) => {
  return createRequest()({
    url: '/api/chart/newTaskinMonth',
    method: 'post',
    data
  })
}

/**
 * 获取延期的任务分部门
 * @param {*} data
 * @returns
 */
export const getDelayTasksReq = (data) => {
  return createRequest()({
    url: '/api/chart/delaytasks',
    method: 'post',
    data
  })
}
