import dayjs from 'dayjs'
import { uploadReq } from '../api/list'

export const downloadUrl = (link) => {
  window.location.href = link
}

export const commonFileUpload = (file) => {
  return new Promise(async (resolve, reject) => {
    try {
      const now = dayjs().format('YYYYMMDDHHmmss')
      const fileSplitLength = file.name.split('.').length
      const fileSuffix = file.name.split('.')[fileSplitLength - 1]
      const fileOriginName = file.name.split('.')[0]
      const newFile = `${fileOriginName}${now}.${fileSuffix}`
      const copyFile = new File([file], `${newFile}`)
      const formData = new FormData()
      formData.append('file', copyFile)
      await uploadReq(formData)
      resolve(`http://172.16.179.5:7001/public/upload/${fileOriginName}${now}.${fileSuffix}`)
    } catch (e) {
      reject(e)
    }
  })
}
