<template>
  <div id="app">
    <loader-overlay/>
    <header>
      <navbar/>
    </header>
    <keep-alive>
      <router-view/>
    </keep-alive>
    <course-observer/>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Navbar from 'components/TheNavbar'
import LoaderOverlay from 'components/TheLoaderOverlay'
import CourseObserver from 'components/course-observer'

export default {
  components: {
    Navbar,
    LoaderOverlay,
    CourseObserver
  },
  computed: {
    ...mapGetters('user', ['userAuthenticated'])
  },
  mounted () {
    // load initial data
    this.$store.dispatch('user/getUserData')
  }
}
</script>
