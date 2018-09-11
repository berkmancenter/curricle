<template>
  <nav
    id="nav-main"
    class="d-none d-md-block h-100 pt-5 px-4">
    <div
      id="logo"
      class="text-center">
      <router-link to="/">
        <img
          class="w-100"
          src="/images/logos/curricle.svg">
      </router-link>
    </div>

    <div id="nav-primary-container">
      <router-link
        class="nav primary"
        to="/explore">
        Explore
      </router-link>

      <br>

      <div
        v-show="activeNavPrimary === 'explore'"
        class="nav-sub-container">
        <router-link
          class="nav sub"
          to="/explore/classes">
          Learning Modes
        </router-link>

        <br>

        <router-link
          class="nav sub"
          to="/explore/instructor">
          Instructor Networks
        </router-link>

        <br>

        <router-link
          class="nav sub"
          to="/explore/universe">
          Course Universe
        </router-link>

        <br>

        <router-link
          class="nav sub"
          to="/explore/keywords">
          Truth vs. Lies
        </router-link>
      </div>

      <router-link
        class="nav primary"
        to="/search">
        Search
      </router-link>

      <br>

      <router-link
        class="nav primary plan"
        to="/plan">
        Plan
      </router-link>

      <br>

      <!-- TODO: Update Plan navigation to use vue-router -->
      <div
        v-show="activeNavPrimary === 'plan'"
        class="nav-sub-container">
        <span
          :class="{ 'router-link-exact-active': viewmode['plan'] === 'list-view' }"
          class="nav sub"
          @click="selectView({ view: 'list-view', type: 'plan' })">
          List
        </span>

        <br>

        <span
          :class="{ 'router-link-exact-active': viewmode['plan'] === 'semester' }"
          class="nav sub"
          @click="selectView({ view: 'semester', type: 'plan' })">
          Week
        </span>

        <br>

        <span
          :class="{ 'router-link-exact-active': viewmode['plan'] === 'multi-year' }"
          class="nav sub"
          href="javascript:null"
          @click="selectView({ view: 'multi-year', type: 'plan' })">
          Semester
        </span>
      </div>
    </div>

    <div
      id="nav-secondary-container"
      class="text-uppercase mt-5">
      <a
        v-if="!userAuthenticated"
        class="nav secondary"
        href="/users/sign_in">
        Sign in
      </a>

      <span
        v-if="userAuthenticated"
        class="nav secondary"
        @click="logout">
        Logout
      </span>

      <br>

      <span
        v-if="userAuthenticated"
        :class="{'tray-active': isTrayVisible}"
        class="nav secondary"
        @click="trayToggle">
        Tray
      </span>
    </div>
  </nav>
</template>

<script>
import { mapGetters, mapActions, mapState } from 'vuex'
import axios from 'axios'

export default {
  computed: {
    ...mapGetters('app', ['isTrayVisible']),
    ...mapGetters('user', ['userAuthenticated']),
    ...mapState('app', ['viewmode']),
    activeNavPrimary () {
      return this.$route.path.split('/')[1]
    }
  },
  methods: {
    ...mapActions('app', ['selectView', 'trayToggle']),
    logout () {
      this.$store.dispatch('user/clearTokens')

      axios.get('/users/sign_out')
    }
  }
}
</script>

<style lang="scss" scoped>
  #nav-main {
    #logo a {
      color: #fff;
    }

    #nav-primary-container {
      margin-top: 250px;
    }

    .nav-sub-container {
      margin: 15px 0;
    }

    .nav {
      padding: 4px 6px;
      display: inline-block;

      &:hover {
        cursor: pointer;
        text-decoration: underline;
      }

      &.primary, &.secondary {
        color: #999;
        margin: 10px 0;
        text-transform: uppercase;
      }

      &.sub {
        color: #777;
        margin-bottom: 10px;

      }

      &.router-link-active {
        color: white;
      }

      &.router-link-exact-active {
        background: white;
        color: black;
        border-radius: 4px;

        &.plan {
          background: inherit;
          color: white;
        }
      }
    }
  }
</style>
