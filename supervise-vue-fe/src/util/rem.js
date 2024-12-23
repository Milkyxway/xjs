// 根据屏幕大小动态设置rem的比例
const baseSize = 32
const setRootFontSize = () => {
  const scale = document.documentElement.clientWidth / 1920
  // 最大放大2倍
  let rootFontSize = baseSize * Math.min(scale, 2)
  // 最小缩放到20px，即0.625，对应宽度为1200px
  rootFontSize = baseSize * Math.max(scale, 0.625)
  document.documentElement.style.fontSize = rootFontSize + 'px'
}
setRootFontSize()
window.addEventListener('resize', setRootFontSize)

export const getClassName = (status) => {
  let className = ''
  switch (status) {
    case 1: //
      className = 'status-confirm'
      break
    case 2:
      className = 'status-adjust'
      break
    case 3:
      className = 'status-processing'
      break
    case 4:
      className = 'status-finish'
      break
    case 5:
      className = 'status-delay'
      break
    case 6:
      className = 'status-submit'
      break
    case 7:
      className = 'status-delay-process'
      break
    default:
      break
  }
  return className
}
