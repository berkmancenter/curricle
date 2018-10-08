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
          src="/images/logos/curricle-black-bg.svg">
      </router-link>
    </div>

    <div
      v-if="userAuthenticated"
      id="nav-primary-container">
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
          Keyword Comparisons
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
      v-if="userAuthenticated"
      id="nav-secondary-container"
      class="text-uppercase mt-5">
      <router-link
        class="nav secondary"
        to="/about">
        About
      </router-link>

      <br>

      <a
        class="nav secondary"
        target="_blank"
        href="http://curricle.wpengine.com">
        Curricle Lens
      </a>
    </div>
  </nav>
</template>

<script>
import { mapActions, mapGetters, mapState } from 'vuex'

export default {
  computed: {
    ...mapGetters('user', ['userAuthenticated']),
    ...mapState('app', ['viewmode']),
    activeNavPrimary () {
      return this.$route.path.split('/')[1]
    }
  },
  methods: {
    ...mapActions('app', ['selectView'])
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
      margin: 10px 0;
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
        margin: 4px 0;
        text-transform: uppercase;
      }

      &.sub {
        color: #777;
        margin-bottom: 4px;
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
