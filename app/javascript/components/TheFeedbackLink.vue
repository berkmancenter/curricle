<template>
  <div
    id="feedback-container"
    class="text-center text-uppercase"
  >
    <a
      :class="{ invert: sidebarCurrentType }"
      target="_blank"
      href="https://docs.google.com/forms/d/e/1FAIpQLSfZdL8a7O51UCurjNinVRx0RJI8ahBdUIf0uHcoNfDt6--Elw/viewform?usp=sf_link"
    >
      <span
        class="d-none d-xl-inline"
      >
        Send your feedback
      </span>

      <font-awesome-icon
        :icon="['far', 'comment-alt']"
        class="ml-2"
      />
    </a>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

export default {
  components: {
    FontAwesomeIcon
  },
  computed: {
    ...mapGetters('app', ['sidebarCurrentType'])
  }
}
</script>

<style lang="scss" scoped>
#feedback-container {
  position: fixed;
  right: 30px;
  bottom: 50px;
  font-size: 14px;

  a {
    color: black;

    &.invert {
      color: white;
    }
  }
}
</style>
