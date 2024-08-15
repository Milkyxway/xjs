import { taskCategory, taskOrigin } from '../constant/index'

export const orgnizationToName = (id, sectionList) => {
  if (!id) return ''
  const orgId = Number(id)
  return sectionList.filter((i) => i.value === orgId)[0].label
}

export const orgnizationNameToId = (name, sectionList) => {
  if (!name) return ''
  return sectionList.filter((i) => i.label === name)[0].value
}

/**
 * 组织id字符串-->组织name字符串
 * @param {*} str
 * @returns
 */
export const orgnizationListIdToName = (str, sectionList) => {
  if (str == '' || !str) {
    return ''
  }
  const listOrg = str.split(',')
  return listOrg
    .map((i) => {
      return sectionList.filter((treeItem) => treeItem.value == i)[0].label
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
