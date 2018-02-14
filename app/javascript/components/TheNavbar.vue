<template>
  <b-navbar
    toggleable="md"
    type="light"
    variant="light">
    <b-navbar-toggle target="nav-collapse"/>
    <b-navbar-brand>
      <b-navbar-nav>
        <basic-search-semester-range/>
      </b-navbar-nav>
    </b-navbar-brand>

    <b-collapse
      id="nav-collapse"
      is-nav>
      <b-navbar-nav
        class="ml-auto"
        v-if="userAuthenticated">
        <b-nav-item to="search">Search</b-nav-item>
        <b-nav-item to="explore">Explore</b-nav-item>
        <b-nav-item to="plan">Plan</b-nav-item>
      </b-navbar-nav>

      <b-navbar-nav class="ml-auto tray-li">
        <b-nav-item
          href="/users/sign_in"
          v-if="!userAuthenticated">
          Sign in
        </b-nav-item>
        <b-nav-item
          @click="logout"
          v-if="userAuthenticated">
          Logout
        </b-nav-item>
        <b-nav-item
          href=""
          @click="trayToggle"
          :class="{'tray-active': isTrayVisible}"
          v-if="userAuthenticated">
          Tray
        </b-nav-item>
      </b-navbar-nav>
    </b-collapse>
  </b-navbar>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import axios from 'axios'
import BasicSearchSemesterRange from 'components/BasicSearchSemesterRange'

export default {
  components: {
    BasicSearchSemesterRange
  },
  computed: {
    ...mapGetters('app', ['isTrayVisible']),
    ...mapGetters('user', ['userAuthenticated'])
  },
  methods: {
    ...mapActions('app', ['trayToggle']),
    logout () {
      this.$store.dispatch('user/clearTokens')

      axios.get('/users/sign_out')
    }
  }
}
</script>
<style type="text/css">
  .tray-li:last-child a{
    padding: 5px 25px !important;
  }
  .tray-active .nav-link, .active.nav-link{
    color: #FFF !important;
    background-color: #000;
    border-radius: 2px;
  }
</style>
