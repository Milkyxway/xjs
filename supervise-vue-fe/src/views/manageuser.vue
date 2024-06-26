<template>
  <QueryUser @handleQuery="handleQuery" />
  <WhiteSpace />
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
      <el-form-item label="密码">
        <el-input
          v-model="state.selectRow.password"
          type="password"
          :show-password="true"
        ></el-input>
      </el-form-item>
      <el-form-item label="角色">
        <SelectCommon
          v-model:select="state.selectRow.role"
          :selections="roleList"
          @updateSelect="
            (val) => {
              if (val !== '') {
                state.selectRow.role = val
              }
            }
          "
        ></SelectCommon>
      </el-form-item>
      <el-form-item label="用户名（中文）">
        <el-input v-model="state.selectRow.usernameCn"></el-input>
      </el-form-item>
    </el-form>

    <el-button type="primary" @click="state.showdialog = false">取消</el-button>
    <el-button @click="updateUser" type="danger">确认</el-button>
  </el-dialog>
</template>
<script setup>
import { ref, reactive } from 'vue'
import Table from '../components/Table.vue'
import SelectCommon from '../components/SelectCommon.vue'
import QueryUser from '../components/QueryUser.vue'
import WhiteSpace from '../components/WhiteSpace.vue'
import { toast } from '../util/toast'
import { roleList } from '../constant/index'
import { getUsersReq, deleteUserReq, updateUserReq } from '../api/login'
import { ElMessageBoxFn } from '../util/toast'
import { getLocalStore } from '../util/localStorage'

const region = ref(getLocalStore('userInfo').region)
const state = reactive({
  userList: [],
  showdialog: false,
  selectRow: 0
})
const userColumns = ref([
  {
    label: '用户名',
    prop: 'username'
  },
  {
    label: '密码',
    prop: 'passwordSensitive'
  },
  {
    label: '角色',
    prop: 'role'
  },
  {
    label: '用户名中文',
    prop: 'usernameCn'
  }
])
const tableOperations = ref([
  {
    label: '删除',
    type: 'danger',
    fn: (row) => {
      ElMessageBoxFn(
        `确定要删除${row.username}?`,
        async () => {
          try {
            await deleteUserReq({ userId: row.userId })
            toast('删除成功！')
            getUsers()
          } catch (e) {}
        },
        () => (state.showdialog = false)
      )
    }
  },
  {
    label: '修改',
    type: 'text',
    fn: (row) => {
      state.showdialog = true
      state.selectRow = row
    }
  }
])
const getUsers = async () => {
  const params = {
    region: region.value
  }
  const result = await getUsersReq(params)
  state.userList = result.data.list.map((i) => {
    return {
      ...i,
      passwordSensitive: '********'
    }
  })
}

const updateUser = async () => {
  const { passwordSensitive, ...rest } = state.selectRow
  await updateUserReq({
    ...rest
  })
  state.showdialog = false
  toast('修改成功！')
  getUsers()
}

const handleQuery = async (query) => {
  state.userList = []
  const result = await getUsersReq({ ...query, region: region.value })
  state.userList = result.data.list.map((i) => {
    return {
      ...i,
      passwordSensitive: '********'
    }
  })
}
getUsers()
</script>
