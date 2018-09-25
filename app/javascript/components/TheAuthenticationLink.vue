<template>
  <div
    id="authentication-container"
    class="text-right text-uppercase">
    <a
      v-if="!userAuthenticated"
      href="/users/sign_in">
      Sign in
    </a>

    <span
      v-if="userAuthenticated"
      class="pointer"
      @click="logout">
      Logout
    </span>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import axios from 'axios'

export default {
  computed: {
    ...mapGetters('user', ['userAuthenticated'])
  },
  methods: {
    logout () {
      this.$store.dispatch('user/clearTokens')

      axios.get('/users/sign_out')
    }
  }
}
</script>

<style lang="scss" scoped>
#authentication-container {
  font-size: 14px;
  position: fixed;
  right: 30px;
  top: 30px;

  a {
    color: black;
  }
}
</style>
