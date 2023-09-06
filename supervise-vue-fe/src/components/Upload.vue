<template>
  <div class="row-item">
    <el-button @click="onUpload" type="primary">{{ props.btnTxt }}</el-button>
    <input ref="uploadRef" type="file" @change="beforeUpload" accept=".xlsx, .xls" hidden />
  </div>
</template>
<script setup>
import { ref } from 'vue'
import * as xlsx from 'xlsx'
const props = defineProps({
  btnTxt: {
    type: String,
    default: '选择文件'
  }
})
const uploadRef = ref()
const beforeUpload = () => {}
const onUpload = () => {}
</script>

<style scoped></style>
