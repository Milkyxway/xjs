<template>
  <el-card>
    <div class="row-item">
      <div class="row-item">
        <span class="item-title">字段名称</span>
        <el-input
          placeholder="请输入需要匹配的字段名称"
          v-model="state.fieldName"
          class="field-input"
          clearable
        ></el-input>
      </div>
      <div class="row-item">
        <el-button @click="onUpload" type="primary">选择文件</el-button>
        <input ref="uploadRef" type="file" @change="beforeUpload" accept=".xlsx, .xls" hidden />
      </div>
    </div>
    <div class="file-row" v-if="state.fileName">
      <div class="row-item icon-margin">
        <el-icon><Files /></el-icon>
        <span>{{ state.fileName }}</span>
      </div>
      <el-icon @click="handleDeleteFile"><Delete /></el-icon>
    </div>
    <div class="type-name">作为条件方式</div>
    <el-input type="textarea" v-model="state.matchArrToStr" rows="10" class="text-area"></el-input>
    <el-button @click="createMatchStr" v-if="state.fileName && !state.matchArrToStr"
      >生成</el-button
    >
    <el-button @click="handleCopy(state.matchArrToStr)" v-if="state.matchArrToStr" type="primary"
      >复制</el-button
    >
    <el-button @click="removeContent('matchArrToStr')" type="plain" v-if="state.matchArrToStr"
      >清空</el-button
    >

    <div class="type-name">建临时表方式</div>
    <div class="row-item">
      <span class="item-title">临时表名称</span>
      <el-input
        placeholder="请输入临时表名称"
        v-model="state.tmpTableName"
        class="field-input"
        clearable
      ></el-input>
    </div>
    <el-input type="textarea" v-model="state.matchArrToSql" rows="10" class="text-area"></el-input>
    <el-button @click="createInsertStr" v-if="state.fileName && !state.matchArrToSql"
      >生成</el-button
    >
    <el-button @click="handleCopy(state.matchArrToSql)" v-if="state.matchArrToSql" type="primary"
      >复制</el-button
    >
    <el-button @click="removeContent('matchArrToSql')" type="plain" v-if="state.matchArrToSql"
      >清空</el-button
    >
  </el-card>
</template>

<script setup>
import * as XLSX from 'xlsx'
import { ref, reactive } from 'vue'
import { copyText } from 'vue3-clipboard'
import { toast } from '../util/toast'

//导入
const uploadRef = ref()
const onUpload = () => {
  uploadRef.value.click()
}
const state = reactive({
  fieldName: '',
  matchArrToStr: '',
  matchArrToSql: '',
  tmpTableName: '',
  excelData: [],
  fileName: ''
})

const beforeUpload = async (e) => {
  await analysisExcel(e.target.files[0])
}
const analysisExcel = (file) => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = (e) => {
      const data = e.target.result
      let datajson = XLSX.read(data, {
        type: 'binary'
      })
      const sheetName = datajson.SheetNames[0]
      const result = XLSX.utils.sheet_to_json(datajson.Sheets[sheetName])
      state.excelData = result
    }
    state.fileName = file.name
    reader.readAsBinaryString(file)
  })
}
const removeContent = (type) => {
  state[type] = ''
}

const createMatchStr = () => {
  const { excelData, fieldName } = state
  const hasField = excelData[0][fieldName] || excelData[0][fieldName.toUpperCase()]
  if (!fieldName) {
    toast('请输入需要匹配的字段名称', 'error')
    return
  }
  if (!hasField) {
    return toast('excel文件中没有匹配到字段名称相同的列', 'error')
  }
  state.matchArrToStr = `(${excelData.map((i) => i[fieldName.toUpperCase()]).join(',')})`
}

const createInsertStr = () => {
  const { tmpTableName, excelData, fieldName } = state
  if (!fieldName) {
    toast('请输入需要匹配的字段名称', 'error')
    return
  }
  if (!tmpTableName) {
    return toast('请填写临时表名称', 'error')
  }
  const hasField = excelData[0][fieldName] || excelData[0][fieldName.toUpperCase()]
  if (!hasField) {
    return toast('excel文件中没有匹配到字段名称相同的列', 'error')
  }
  state.matchArrToSql = excelData
    .map((i, k) => `insert into ${tmpTableName} values(${k + 1}, ${i[fieldName.toUpperCase()]});\n`)
    .join('')
}

const handleCopy = (content) => {
  copyText(content, undefined, (error, event) => {
    if (error) {
      toast('复制失败！', 'error')
      console.log(error)
    } else {
      toast('复制成功！')
      console.log(event)
    }
  })
}

const handleDeleteFile = () => {
  state.excelData = []
  state.fileName = ''
}
</script>

<style scoped>
.row-item {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: center;
}
.item-title {
  display: inline-block;
  width: 100px;
  text-align: left;
}
.field-input {
  width: 250px;
  margin-right: 20px;
}
.text-area {
  margin: 20px 0;
}
.file-row {
  color: #aaa;
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: center;
}

.icon-margin {
  margin: 0 20px 0 0;
}

.type-name {
  font-weight: bold;
  text-align: left;
}
</style>
