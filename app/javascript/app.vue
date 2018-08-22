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

        <div
          id="feedback-container"
          class="text-center text-uppercase">
          <a
            :class="{ invert: sidebarCurrentType }"
            target="_blank"
            href="https://docs.google.com/forms/d/e/1FAIpQLSfZdL8a7O51UCurjNinVRx0RJI8ahBdUIf0uHcoNfDt6--Elw/viewform?usp=sf_link">
            Send your feedback

            <font-awesome-icon
              :icon="['far', 'comment-alt']"
              class="ml-2"/>
          </a>
        </div>
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
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

export default {
  components: {
    Navbar,
    LoaderOverlay,
    CourseObserver,
    TheSidebar,
    FontAwesomeIcon
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

#feedback-container {
  position: fixed;
  right: 30px;
  bottom: 50px;
  font-size: 14px;

  a {
    color: black;

    &.invert {
      color: white;
    }
  }
}
</style>
