<template>
  <div id="app">
    <header>
      <navbar/>
      <keep-alive>
        <router-view/>
      </keep-alive>
    </header>
  </div>
</template>

<script>
import Navbar from 'components/TheNavbar'

export default {
  components: {
    Navbar
  },
  mounted () {
    // load initial data
    this.$store.dispatch('user/getUserData')
  }
}
</script>
