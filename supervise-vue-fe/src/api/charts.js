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
