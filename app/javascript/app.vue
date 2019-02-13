<template>
  <div id="app">
    <loader-overlay />

    <the-navbar-control
      v-if="userAuthenticated"
      v-show="sidebarCurrentType === 'tray'"
    />

    <the-tray-control
      v-if="userAuthenticated"
      v-show="sidebarCurrentType !== 'tray'"
    />

    <the-logout-link
      v-if="userAuthenticated"
      v-show="sidebarCurrentType !== 'tray'"
    />

    <div class="row h-100">
      <div
        v-show="sidebarCurrentType !== 'tray'"
        id="nav-container"
        :class="{ active: sidebarCurrentType !== 'tray' }"
        class="col-md-2 px-0"
      >
        <navbar />
      </div>

      <div
        id="main-container"
        class="col-md-10 h-100"
      >
        <the-alert />

        <keep-alive>
          <router-view />
        </keep-alive>

        <selected-course
          v-if="selectedCourse"
          :course="selectedCourse"
          :user-authenticated="userAuthenticated"
        />

        <the-data-last-updated-indicator />
      </div>

      <div
        v-show="sidebarCurrentType === 'tray'"
        id="sidebar-container"
        :class="{ active: sidebarCurrentType === 'tray' }"
        class="col-md-2 px-0"
      >
        <the-sidebar />
      </div>
    </div>

    <course-observer />
  </div>
</template>

<script>
import { mapGetters, mapState } from 'vuex'
import Navbar from 'components/TheNavbar'
import LoaderOverlay from 'components/TheLoaderOverlay'
import CourseObserver from 'components/course-observer'
import SelectedCourse from 'components/shared/SelectedCourse'
import TheLogoutLink from 'components/TheLogoutLink'
import TheSidebar from 'components/TheSidebar'
import TheTrayControl from 'components/TheTrayControl'
import TheDataLastUpdatedIndicator from 'components/TheDataLastUpdatedIndicator'
import TheNavbarControl from 'components/TheNavbarControl'
import TheAlert from 'components/TheAlert'

export default {
  components: {
    Navbar,
    LoaderOverlay,
    CourseObserver,
    SelectedCourse,
    TheLogoutLink,
    TheSidebar,
    TheTrayControl,
    TheDataLastUpdatedIndicator,
    TheNavbarControl,
    TheAlert
  },
  computed: {
    ...mapGetters('user', ['userAuthenticated']),
    ...mapGetters('app', ['sidebarCurrentContext', 'sidebarCurrentType']),
    ...mapState('app', ['selectedCourse'])
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

#nav-container.active,
#sidebar-container.active {
  background-color: #000;
  color: #fff;
}

#main-container {
  padding: 0 5%;
}
</style>
