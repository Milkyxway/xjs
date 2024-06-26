import { orgnizationTree, taskCategory, taskOrigin, orgnizationTree_jy } from '../constant/index'
import { getLocalStore } from './localStorage'

export const orgnizationToName = (id) => {
  if (!id) return ''
  const orgId = Number(id)
  const region = getLocalStore('userInfo').region
  return getOrgnizationListByRegion(region).filter((i) => i.value === orgId)[0].label
}

export const orgnizationNameToId = (name) => {
  if (!name) return ''
  const region = getLocalStore('userInfo').region
  return getOrgnizationListByRegion(region).filter((i) => i.label === name)[0].value
}

/**
 * 组织id字符串-->组织name字符串
 * @param {*} str
 * @returns
 */
export const orgnizationListIdToName = (str) => {
  if (str == '' || !str) {
    return ''
  }
  const listOrg = str.split(',')
  const region = getLocalStore('userInfo').region
  return listOrg
    .map((i) => {
      return getOrgnizationListByRegion(region).filter((treeItem) => treeItem.value == i)[0].label
    })
    .join('、')
}

export const taskCategoryNameToId = (name) => {
  if (!name) return ''
  return taskCategory.filter((i) => i.label === name)[0].value
}

export const taskSourceNameToId = (name) => {
  if (!name) return ''
  return taskOrigin.filter((i) => i.label === name)[0].value
}

export const getOrgnizationListByRegion = (region) =>
  region === 'wx' ? orgnizationTree : orgnizationTree_jy
