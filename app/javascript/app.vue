<template>
  <div
    id="app"
    class="overflow-hidden"
  >
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

    <div class="row">
      <div
        v-show="sidebarCurrentType !== 'tray'"
        id="nav-container"
        :class="{ active: sidebarCurrentType !== 'tray' }"
        class="col-md-2"
      >
        <navbar />
      </div>

      <div
        id="main-container"
        class="col-md-10"
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
      </div>

      <div
        v-show="sidebarCurrentType === 'tray'"
        id="sidebar-container"
        :class="{ active: sidebarCurrentType === 'tray' }"
        class="col-md-2"
      >
        <the-sidebar />
      </div>

      <the-footer />
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
import TheFooter from 'components/TheFooter'
import TheLogoutLink from 'components/TheLogoutLink'
import TheSidebar from 'components/TheSidebar'
import TheTrayControl from 'components/TheTrayControl'
import TheNavbarControl from 'components/TheNavbarControl'
import TheAlert from 'components/TheAlert'

export default {
  components: {
    Navbar,
    LoaderOverlay,
    CourseObserver,
    SelectedCourse,
    TheFooter,
    TheLogoutLink,
    TheSidebar,
    TheTrayControl,
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
#app {
  height: 100vh;
}

#nav-container,
#main-container,
#sidebar-container {
  height: 100vh;
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
