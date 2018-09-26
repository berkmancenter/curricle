<template>
  <div
    id="home-content">
    <div
      class="mb-5">
      <img
        id="logo"
        class="mb-5"
        src="/images/logos/curricle-white-bg.svg">

      Curricle will help you
      <router-link
        to="/explore">
        <strong>explore</strong>
      </router-link>
      the Harvard<br>
      curriculum, past and present,<br>
      <router-link
        to="/plan">
        <strong>plan</strong>
      </router-link>
      your semester schedule,<br>
      and
      <router-link
        to="/search">
        <strong>search</strong>
      </router-link>
      by keywords.
    </div>

    <authentication-link
      v-if="!userAuthenticated"/>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import AuthenticationLink from 'components/shared/AuthenticationLink.vue'

export default {
  components: {
    AuthenticationLink
  },
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
</style>
