<template>
  <div id="app">
    <header>
      <navbar/>
      <keep-alive v-if="userAuthenticated">
        <router-view/>
      </keep-alive>
      <div v-if="!userAuthenticated">
        <br>
        Please use the "Sign in" link in the navbar.
      </div>
    </header>
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
