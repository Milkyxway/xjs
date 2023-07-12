export const getLocalStore = (key) => {
  return JSON.parse(localStorage.getItem(key))
}

export const setLocalStore = (key, val) => {
  setLocalStore(key, JSON.stringify(val))
}
