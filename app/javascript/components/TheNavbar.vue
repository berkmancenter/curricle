<template>
  <nav
    id="nav-main"
    class="d-none d-md-block pt-5 px-4"
  >
    <div
      id="logo"
      class="text-center"
    >
      <router-link to="/">
        <img
          class="w-100"
          src="/images/logos/curricle-black-bg.svg"
        >
      </router-link>
    </div>

    <div
      v-if="userAuthenticated"
      id="nav-primary-container"
      class="mt-5"
    >
      <router-link
        class="nav primary"
        to="/explore"
      >
        Explore
      </router-link>

      <br>

      <div
        v-show="activeNavPrimary === 'explore'"
        class="nav-sub-container"
      >
        <router-link
          class="nav sub"
          to="/explore/classes"
        >
          Learning Styles
        </router-link>

        <br>

        <router-link
          class="nav sub"
          to="/explore/instructor"
        >
          Instructor Networks
        </router-link>

        <br>

        <router-link
          class="nav sub"
          to="/explore/universe"
        >
          Course Universe
        </router-link>

        <br>

        <router-link
          class="nav sub"
          to="/explore/keywords"
        >
          Keyword Comparisons
        </router-link>
      </div>

      <router-link
        class="nav primary"
        to="/search"
      >
        Search
      </router-link>

      <br>

      <div
        v-show="activeNavPrimary === 'search'"
        class="nav-sub-container"
      >
        <router-link
          class="nav sub"
          to="/search/advanced"
        >
          Advanced Search
        </router-link>
      </div>

      <router-link
        class="nav primary"
        to="/plan"
      >
        Plan
      </router-link>

      <br>

      <div
        v-show="activeNavPrimary === 'plan'"
        class="nav-sub-container"
      >
        <router-link
          class="nav sub"
          to="/plan/list"
        >
          List
        </router-link>

        <br>

        <router-link
          class="nav sub"
          to="/plan/week"
        >
          Week
        </router-link>

        <br>

        <router-link
          class="nav sub"
          to="/plan/semester"
        >
          Semester
        </router-link>
      </div>
    </div>

    <div
      v-if="userAuthenticated"
      id="nav-secondary-container"
      class="text-uppercase mt-5"
    >
      <router-link
        class="nav secondary"
        to="/about"
      >
        About
      </router-link>

      <br>

      <a
        class="nav secondary"
        target="_blank"
        href="http://curricle.wpengine.com"
      >
        Curricle Lens
      </a>
    </div>
  </nav>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters('user', ['userAuthenticated']),
    activeNavPrimary () {
      return this.$route.path.split('/')[1]
    }
  }
}
</script>

<style lang="scss" scoped>
  #nav-main {
    #logo a {
      color: #fff;
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

      &.primary,
      &.secondary {
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
      }
    }
  }
</style>
