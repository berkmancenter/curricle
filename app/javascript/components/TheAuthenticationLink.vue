<template>
  <div
    id="authentication-container"
    class="text-right text-uppercase"
  >
    <span
      v-if="userAuthenticated"
      class="pointer"
      @click="logout"
    >
      Logout
    </span>

    <a
      v-else
      href="/users/sign_in"
    >
      Sign In
    </a>
  </div>
</template>

<script>
export default {
  props: {
    userAuthenticated: {
      type: Boolean,
      required: true
    }
  },
  methods: {
    logout () {
      this.$store.dispatch('user/clearTokens')

      window.location = '/users/sign_out'
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
  z-index: 999;

  a {
    color: black;
  }
}
</style>
