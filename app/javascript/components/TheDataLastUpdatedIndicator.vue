<template>
  <div v-if="updatedAt">
    Data last updated on {{ updatedAt }}
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
