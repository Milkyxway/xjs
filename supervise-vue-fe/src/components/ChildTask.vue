<template>
  <div class="row-item">
    <div class="row-item">
      <span class="paddingLR10">完成目标</span>
      <el-input v-model="props.data.taskGoal"></el-input>
    </div>
    <div class="row-item">
      <span class="paddingLR10">完成时间</span>
      <el-date-picker v-model="props.data.finishTime"></el-date-picker>
    </div>
    <div class="row-item" v-if="props.data.status == 5">
      <span class="paddingLR10">延期说明</span>
      <el-input></el-input>
    </div>
    <el-icon color="#409eff" @click="addChild" v-if="props.isFirst">
      <CirclePlus />
    </el-icon>
    <el-icon @click="deleteChild(index)" v-if="!props.isFirst"><Delete /></el-icon>
  </div>
</template>
<script setup>
const props = defineProps({
  data: {
    type: Object,
    default: {}
  },
  isFirst: {
    type: Boolean,
    default: true
  }
})
const emits = defineEmits(['addChild', 'deleteChild'])

const addChild = () => {
  emits('addChild')
}

const deleteChild = () => {
  emits('deleteChild')
}
</script>
<style scoped>
.row-item {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: center;
  white-space: nowrap;
}
.paddingLR10 {
  padding: 0 10px;
}
</style>
