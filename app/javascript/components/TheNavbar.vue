<template>
  <nav
    id="main-nav"
    class="d-none d-md-block h-100 pt-4 px-4">
    <div
      id="logo"
      class="text-center">
      <router-link to="/">
        <h1>The Catalog</h1>
      </router-link>
    </div>

    <div
      id="primary-nav"
      class="text-uppercase">
      <router-link to="/explore">Explore</router-link>
      <router-link to="/search">Search</router-link>
      <router-link to="/plan">Plan</router-link>
    </div>

    <div
      id="secondary-nav"
      class="text-uppercase mt-5">
      <a
        v-if="!userAuthenticated"
        href="/users/sign_in">
        Sign in
      </a>

      <a
        v-if="userAuthenticated"
        href="javascript:null"
        @click="logout">
        Logout
      </a>

      <a
        v-if="userAuthenticated"
        :class="{'tray-active': isTrayVisible}"
        href="javascript:null"
        @click="trayToggle">
        Tray
      </a>
    </div>
  </nav>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import axios from 'axios'

export default {
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

<style lang="scss" scoped>
  #main-nav {
    background-color: #000;
    color: #fff;

    #logo a {
      color: #fff;
    }

    #primary-nav {
      margin-top: 250px;
    }

    #primary-nav a, #secondary-nav a {
      color: #999;
      display: block;
      margin: 20px 0;

      &.router-link-active {
        color: #fff;
      }
    }
  }
</style>
