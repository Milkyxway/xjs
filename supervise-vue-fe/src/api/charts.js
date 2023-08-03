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
