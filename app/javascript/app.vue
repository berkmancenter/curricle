<template lang="pug">
  #app
    header
      navbar

    router-view(:resultSet="results")
</template>

<script>
import Navbar from 'components/navbar.vue'

export default {
  components: {
    Navbar
  },
  mounted () {
    // load initial data
    this.$store.dispatch("user/getCourses")
  },
  data(){
    return {
      results: []

    }  
  },
}
</script>
