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

      <p class="mb-5">
        Curricle will help you<br>
        <router-link
          class="text-decoration-none"
          to="/explore"
        >
          <strong>explore</strong>
        </router-link>
        the Harvard curriculum, past and present,<br>
        <router-link
          class="text-decoration-none"
          to="/search"
        >
          <strong>search</strong>
        </router-link>
        courses by keywords, and<br>
        <router-link
          class="text-decoration-none"
          to="/plan"
        >
          <strong>plan</strong>
        </router-link>
        your semester schedule.<br>
        Then go to
        <a href="https://portal.my.harvard.edu">
          My.Harvard</a>
        to complete registration.
      </p>

      <p>
        <strong>
          <em>
            Curricle is preparing for its launch in Fall 2019!
          </em>
        </strong>

        <br>

        <em>
          Check out our
          <a
            href="http://curricledev.wpengine.com/"
            target="_blank"
          >
            development blog</a>
          for the latest update and new features.
        </em>
      </p>
    </div>

    <span
      v-if="!userAuthenticated"
      id="login-link-container"
    >
      <a
        class="text-decoration-none"
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
      max-width: 100%;
      width: auto;
    }

    a {
      color: black;
      text-decoration: underline;
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
