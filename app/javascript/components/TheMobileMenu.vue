<template>
  <b-navbar
    toggleable="lg"
    type="dark"
  >
    <b-navbar-toggle target="nav-collapse" />

    <router-link to="/">
      <img
        class="w-50 pull-right"
        src="/images/logos/curricle-black-bg.svg"
      >
    </router-link>

    <b-collapse
      id="nav-collapse"
      class="mt-3"
      is-nav
    >
      <b-navbar-nav>
        <b-nav-item
          class="mt-3"
          @click="trayToggle"
        >
          Schedule
        </b-nav-item>

        <b-nav-item
          class="mt-3"
          to="/explore"
        >
          Explore
        </b-nav-item>

        <b-nav-item to="/search">
          Search
        </b-nav-item>

        <b-nav-item to="/plan">
          Plan
        </b-nav-item>

        <b-nav-item
          class="mt-4"
          to="/tools"
        >
          Tools
        </b-nav-item>

        <b-nav-item
          to="/about"
        >
          About
        </b-nav-item>

        <b-nav-item
          target="_blank"
          href="http://curricle.wpengine.com"
        >
          Development Updates
        </b-nav-item>
      </b-navbar-nav>
    </b-collapse>
  </b-navbar>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  methods: {
    ...mapActions('app', ['trayToggle'])
  }
}
</script>

<style scoped>
nav.navbar {
  background-color: black;
}

.navbar-dark .navbar-nav .nav-link {
  color: white;
  font-size: 1.5rem;
  text-transform: uppercase;
}
</style>
