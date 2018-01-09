<template lang="pug">
  #app
    header
      navbar(:trayToggle="trayToggle" :trayVisible="trayVisible")

    router-view(:trayVisible="trayVisible" :searchedResults="searchedResults" :resultSet="results")
</template>

<script>
import Navbar from 'components/navbar.vue'

export default {
  components: {
    Navbar
  },
  data(){
    return {
      trayVisible: false,
      results: []

    }  
  },

  methods: {
    trayToggle(){
      this.trayVisible = !this.trayVisible
    },
    searchedResults(results){
      this.results = results
    }
  }

}
</script>
