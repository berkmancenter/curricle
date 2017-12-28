<template lang="pug">
  #app
    header
      navbar(:trayToggle="trayToggle")

    router-view(:trayVisible="trayVisible")
</template>

<script>
import Navbar from 'components/navbar.vue'

export default {
  components: {
    Navbar
  },
  data(){
    return {
      trayVisible: false
    }  
  },

  methods: {
    trayToggle(){
      this.trayVisible = !this.trayVisible
    }
  }

}
</script>
