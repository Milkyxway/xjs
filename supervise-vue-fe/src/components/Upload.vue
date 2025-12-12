<template>
  <div class="row-item">
    <el-button @click="onUpload" type="primary" plain>{{ props.btnTxt }}</el-button>
    <input
      ref="uploadRef"
      type="file"
      @change="beforeUpload"
      accept=".xlsx, .xls, .doc, .docx, .pdf, .ppt"
      hidden
    />
  </div>
</template>
<script setup>
import { ref } from 'vue'
import * as XLSX from 'xlsx'
const props = defineProps({
  btnTxt: {
    type: String,
    default: '选择文件'
  },
  needAnalysis: {
    type: Boolean,
    default: false
  }
})
const uploadRef = ref()
const emits = defineEmits(['handleChange'])

const onUpload = () => {
  uploadRef.value.click()
}
const beforeUpload = async (e) => {
  if (props.needAnalysis) {
    analysisExcel(e.target.files[0])
  } else {
    emits('handleChange', e.target.files[0])
  }
}
const analysisExcel = (file) => {
  const reader = new FileReader()
  reader.onload = (e) => {
    const data = e.target.result
    let datajson = XLSX.read(data, {
      type: 'binary'
    })
    const sheetName = datajson.SheetNames[0]
    const result = XLSX.utils.sheet_to_json(datajson.Sheets[sheetName])
    emits('handleChange', result)
  }
  reader.readAsBinaryString(file)
}
</script>

<style scoped></style>
