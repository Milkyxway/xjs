<template>
  <el-card>
    <form :v-model="queryForm">
      <div class="row-item">
        <div class="query-select">
          <span class="query-title">用户名</span>
          <el-input
            v-model="queryForm.username"
            placeholder="请输入用户名或用户名中文"
            clearable
          ></el-input>
        </div>
      </div>
    </form>
    <div class="btn-wrap">
      <el-button @click="reset" plain>重置查询</el-button>
      <el-button @click="handleQuery" type="primary">查询</el-button>
    </div>
  </el-card>
</template>
<script setup>
import { ref, reactive, computed } from 'vue'
const emit = defineEmits(['handleQuery'])
let queryForm = reactive({
  username: ''
})

const handleQuery = () => {
  emit('handleQuery', queryForm)
}

const reset = () => {
  Object.keys(queryForm).map((i) => {
    queryForm[i] = null
  })
  handleQuery()
}
</script>
<style scoped>
.row-item {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: center;
  flex-wrap: wrap;
}

.query-select {
  margin: 0 20px 10px 0;
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  /* align-items: center; */
  /* flex: auto; */
}
.query-select-keyword {
  margin: 0 20px 10px 0;
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
}
.query-title {
  display: inline-block;
  width: 60px;
  margin-right: 10px;
  white-space: nowrap;
}
.white-space {
  height: 10px;
}
.btn-wrap {
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
  align-items: center;
  padding: 15px 0 0 0;
}
.upload-wrap {
  margin: 0 0 0 15px;
}
.card-admin {
  border: none;
  :deep(.el-input) {
    width: 195px !important;
  }
  :deep(.el-input__wrapper) {
    width: 195px !important;
    /* border: 1px solid #7f7fd5; */
    /* border-radius: 4px; */
  }
}
.card-section {
  border: none;
  :deep(.el-input) {
    width: 280px !important;
  }
  :deep(.el-input__wrapper) {
    width: 280px !important;
    /* border: 1px solid #7f7fd5; */
    /* border-radius: 4px; */
  }
}
</style>
