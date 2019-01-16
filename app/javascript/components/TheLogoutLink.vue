<template>
  <div
    id="authentication-container"
    class="text-right text-uppercase"
  >
    <span
      class="pointer"
      @click="logout"
    >
      Logout
    </span>
  </div>
</template>

<script>
export default {
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
