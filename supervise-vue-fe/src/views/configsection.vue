<template>
  <el-card>
    <!-- <form :v-model="state.search">
      <div class="row-item">
        <div class="query-select">
          <span class="query-title">部门名称</span>
          <el-input
            v-model="state.search.searchName"
            placeholder="请输入部门名称"
            clearable
          ></el-input>
        </div>
      </div>
    </form> -->
    <el-button @click="clickAdd" type="primary">创建部门</el-button>
  </el-card>
  <WhiteSpace />
  <el-table :data="state.tableData">
    <el-table-column
      v-for="item in tableColumns"
      :label="item.columnName"
      :prop="item.prop"
      :key="item.key"
    ></el-table-column>
    <el-table-column fixed="right" label="操作" width="150">
      <template #default="{ row }">
        <el-button link type="info" size="small" @click="clickUpdate(row)">修改</el-button>
      </template>
    </el-table-column>
  </el-table>
  <el-dialog
    :show-close="false"
    :close-on-press-escape="false"
    v-model="state.modalVisible"
    :title="state.modalTitle"
  >
    <el-form :model="form" ref="formRef">
      <el-form-item
        label="部门名称"
        :label-width="formLabelWidth"
        prop="columnName"
        :rules="rules('请输入部门名称')"
      >
        <el-input v-model="form.sectionName"></el-input>
      </el-form-item>
    </el-form>
    <template #footer>
      <span class="dialog-footer">
        <el-button
          @click="
            () => {
              form.sectionName = ''
              state.modalVisible = false
            }
          "
          >取消</el-button
        >
        <el-button
          type="primary"
          @click="state.modalTitle === '修改部门' ? updateSectionName() : addSection()"
        >
          确定
        </el-button>
      </span>
    </template>
  </el-dialog>
</template>
<script setup>
import { ref, reactive, computed } from 'vue'
import { getOrgListReq, updateSectionNameReq, addSectionReq } from '../api/list'
import { getLocalStore } from '../util/localStorage'
import { toast } from '../util/toast'
import WhiteSpace from '../components/WhiteSpace.vue'
const orgList = ref([])
const state = reactive({
  tableData: [],
  modalVisible: false,
  selectSection: '',
  modalTitle: '',
  search: {
    searchName: ''
  }
})
const formRef = ref()
const form = reactive({
  sectionName: ''
})

const tableColumns = [
  {
    columnName: '部门编号',
    prop: 'sectionId'
  },

  {
    columnName: '部门名称',
    prop: 'sectionName'
  }
]
const region = getLocalStore('userInfo').region
const role = getLocalStore('userInfo').role

const rules = computed(() => {
  return function (message) {
    return [
      {
        required: true,
        trigger: 'change',
        message
      }
    ]
  }
})
const getOrgList = async () => {
  const result = await getOrgListReq({ region })
  state.tableData = result.data
}

const clickUpdate = (row) => {
  form.sectionName = row.sectionName
  state.selectSection = row.sectionId
  state.modalTitle = '修改部门'
  state.modalVisible = true
}

const updateSectionName = async () => {
  try {
    await updateSectionNameReq({
      sectionId: state.selectSection,
      sectionName: form.sectionName
    })
    state.modalVisible = false
    toast('修改成功！')
    getOrgList()
  } catch (e) {}
}

const clickAdd = () => {
  state.modalTitle = '创建部门'
  state.modalVisible = true
}

const addSection = async () => {
  formRef.value.validate(async (res) => {
    await addSectionReq({
      sectionName: form.sectionName,
      region
    })
    state.modalVisible = false
    toast('创建成功！')
    getOrgList()
  })
}

getOrgList()
</script>
