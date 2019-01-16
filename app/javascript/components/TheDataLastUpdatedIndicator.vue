<template>
  <div
    v-if="updatedAt"
    id="data-last-updated"
  >
    Data last refreshed on {{ updatedAt }}
  </div>
</template>

<script>
export default {
  computed: {
    updatedAt () {
      return localStorage.getItem('curricle_data_updated_at')
    }
  }
}
</script>

<style scoped>
#data-last-updated {
  bottom: 5px;
  color: #aaa;
  font-family: 'IBM Sans Mono', monospace;
  font-size: 11px;
  margin-left: 10px;
  position: fixed;
}
</style>
