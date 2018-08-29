<template>
  <div id="app">
    <loader-overlay/>

    <div class="row h-100">
      <div
        id="nav-container"
        class="col-md-2 px-0">
        <navbar/>
      </div>

      <div
        id="main-container"
        class="col-md-8">
        <keep-alive>
          <router-view/>
        </keep-alive>
      </div>

      <div
        id="sidebar-container"
        :class="{ active: sidebarCurrentType }"
        class="col-md-2 px-0">
        <the-sidebar />

        <the-feedback-link/>
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
import TheSidebar from 'components/TheSidebar'
import TheFeedbackLink from 'components/TheFeedbackLink'

export default {
  components: {
    Navbar,
    LoaderOverlay,
    CourseObserver,
    TheSidebar,
    TheFeedbackLink
  },
  computed: {
    ...mapGetters('user', ['userAuthenticated']),
    ...mapGetters('app', ['sidebarCurrentType'])
  },
  mounted () {
    // load initial data
    this.$store.dispatch('user/getUserData')
  }
}
</script>

<style lang="scss" scoped>
#nav-container,
#main-container,
#sidebar-container {
  overflow: auto;
}

#nav-container,
#sidebar-container.active {
  background-color: #000;
  color: #fff;
}
</style>
