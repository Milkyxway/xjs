<template>
  <Table
    :tableData="state.userList"
    :tableColumns="userColumns"
    :tableOperations="tableOperations"
    noPagination
  />
  <el-dialog
    :show-close="false"
    :close-on-press-escape="false"
    :close-on-click-modal="false"
    v-model="state.showdialog"
    title="修改用户"
    :destroy-on-close="true"
  >
    <el-form>
      <el-form-item label="用户名">
        <el-input v-model="state.selectRow.username"></el-input>
      </el-form-item>
      <el-form-item label="用户名">
        <el-input v-model="state.selectRow.usernameCn"></el-input>
      </el-form-item>
      <el-form-item label="分管部门">
        <el-select
          v-model="form.manageParts"
          placeholder="请选择分管部门(可多选)"
          clearable
          multiple
          ><el-option
            v-for="item in sectionList"
            :label="item.label"
            :value="item.value"
            v-bind:key="item.key"
            >{{ item.label }}</el-option
          ></el-select
        >
      </el-form-item>
    </el-form>

    <el-button
      type="primary"
      @click="
        () => {
          state.showdialog = false
          state.selectRow = {}
          form.manageParts = ''
        }
      "
      >取消</el-button
    >
    <el-button @click="updateUser" type="danger">确认</el-button>
  </el-dialog>
</template>
<script setup>
import { ref, reactive } from 'vue'
import Table from '../components/Table.vue'
import { getUsersReq, updateUserReq } from '../api/login'
import { orgnizationListIdToName } from '../util/orgnization'
import { toast } from '../util/toast'
import { getLocalStore } from '../util/localStorage'
import { storeToRefs } from 'pinia'
import { sectionStore } from '../stores/orgList'

const setionStore = sectionStore()
const { sectionList } = storeToRefs(setionStore)

const region = ref(getLocalStore('userInfo').region)
const state = reactive({
  userList: [],
  showdialog: false,
  selectRow: 0
})

let form = reactive({
  manageParts: ''
})
const userColumns = ref([
 
  {
    label: '用户名',
    prop: 'usernameCn'
  },
  {
    label: '分管部门',
    prop: 'manageParts'
  }
])
const tableOperations = ref([
  {
    label: '修改',
    type: 'text',
    fn: (row) => {
      state.showdialog = true
      state.selectRow = row
      form.manageParts = row.managePartsCp.split(',').map((i) => Number(i))
    }
  }
])
const getUsers = async () => {
  await setionStore.getOrgList()
  const params = {
    region: region.value,
    role: 'sub-leader'
  }
  const result = await getUsersReq(params)
  state.userList = result.data.list.map((i) => {
    return {
      ...i,
      manageParts: orgnizationListIdToName(i.manageParts, sectionList.value),
      managePartsCp: i.manageParts
    }
  })
}

const updateUser = async () => {
  await updateUserReq({
    ...state.selectRow,
    manageParts: form.manageParts.join(',')
  })
  state.showdialog = false
  toast('修改成功！')
  getUsers()
}

getUsers()
</script>
