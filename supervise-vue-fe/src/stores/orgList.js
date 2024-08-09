import { ref } from 'vue'
import { defineStore } from 'pinia'
import { getOrgListReq } from '../api/list'
import { getLocalStore } from '../util/localStorage'

const region = getLocalStore('userInfo').region

// 使用setup模式定义
export const sectionStore = defineStore({
  id: 'sectionList',
  state: () => ({
    sectionList: []
  }),
  actions: {
    async getOrgList() {
      const result = await getOrgListReq({ region })
      this.sectionList = result.data.map((i) => {
        return {
          value: i.sectionId,
          label: i.sectionName
        }
      })
    }
  }
})
