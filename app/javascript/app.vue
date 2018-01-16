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
  data(){
    return {
      results: []

    }  
  },
}
</script>
