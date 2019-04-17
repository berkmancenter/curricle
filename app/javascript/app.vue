<template>
  <div
    id="app"
    class="overflow-hidden"
  >
    <loader-overlay />

    <the-mobile-menu
      class="d-block d-sm-none"
    />

    <the-navbar-control
      v-if="userAuthenticated && sidebarVisible"
      class="d-none d-sm-block"
    />

    <the-tray-control
      v-if="userAuthenticated && !sidebarVisible"
      class="d-none d-sm-block"
    />

    <the-logout-link
      v-if="userAuthenticated && !sidebarVisible"
      class="d-none d-sm-block"
    />

    <div class="row">
      <div
        v-if="!sidebarVisible"
        id="nav-container"
        :class="{ active: !sidebarVisible }"
        class="col-sm-2 d-none d-sm-block"
      >
        <navbar />
      </div>

      <div
        id="main-container"
        class="col-sm-10 d-sm-block"
        :class="{ 'd-none': sidebarVisible }"
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
        v-if="sidebarVisible"
        id="sidebar-container"
        :class="{ active: sidebarVisible, 'col-12': sidebarVisible }"
        class="col-sm-2"
      >
        <the-sidebar />
      </div>

      <the-footer class="d-none d-sm-flex" />
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
import TheMobileMenu from 'components/TheMobileMenu'

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
    TheAlert,
    TheMobileMenu
  },
  computed: {
    ...mapGetters('user', ['userAuthenticated']),
    ...mapGetters('app', ['sidebarCurrentContext', 'sidebarCurrentType']),
    ...mapState('app', ['selectedCourse']),
    sidebarVisible () {
      return this.sidebarCurrentType === 'tray'
    }
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
