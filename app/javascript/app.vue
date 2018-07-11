<template>
  <div id="app">
    <loader-overlay/>

    <div class="row h-100">
      <div class="col-md-2 px-0">
        <navbar/>
      </div>

      <div class="col-md-10">
        <keep-alive>
          <router-view/>
        </keep-alive>
      </div>

    </div>

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
