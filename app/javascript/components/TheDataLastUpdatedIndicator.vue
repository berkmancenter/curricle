<template>
  <div v-if="updatedAt">
    Data last updated on {{ updatedAt }}. See <a href="https://my.harvard.edu/">my.harvard</a> for the most recent changes to courses.
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
a {
   color: black;
}
</style>
