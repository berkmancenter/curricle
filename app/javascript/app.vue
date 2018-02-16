<template>
  <div id="app">
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
import CourseObserver from 'components/course-observer'

export default {
  components: {
    Navbar,
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
