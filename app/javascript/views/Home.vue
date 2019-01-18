<template>
  <div
    id="home-content"
  >
    <div
      class="mb-5"
    >
      <img
        id="logo"
        class="mb-5"
        src="/images/logos/curricle-white-bg.svg"
      >

      Curricle will help you<br>
      <router-link
        to="/explore"
      >
        <strong>explore</strong>
      </router-link>
      the Harvard curriculum, past and present,<br>
      <router-link
        to="/search"
      >
        <strong>search</strong>
      </router-link>
      courses by keywords, and<br>
      <router-link
        to="/plan"
      >
        <strong>plan</strong>
      </router-link>
      your semester schedule.<br>
      Then go to
      <a href="https://portal.my.harvard.edu">
        My.Harvard</a>
      to complete registration.
    </div>

    <span
      v-if="!userAuthenticated"
      id="login-link-container"
    >
      <a
        href="/users/sign_in"
      >
        Sign in with HarvardKey
      </a>
    </span>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters('user', ['userAuthenticated'])
  }
}
</script>

<style lang="scss" scoped>
  #home-content {
    color: black;
    font-size: 30px;
    line-height: 34px;
    margin-left: 5%;
    margin-top: 20%;

    img#logo {
      display: block;
      height: 80px;
      width: auto;
    }

    a {
      color: black;
    }
  }

  #login-link-container {
    display: inline-block;
    background: black;
    color: white;
    font-size: 24px;
    padding: 20px 30px;

    a {
      color: white;
    }
  }
</style>
