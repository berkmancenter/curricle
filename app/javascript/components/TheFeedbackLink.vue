<template>
  <div
    id="feedback-container"
    class="text-uppercase"
  >
    <a
      target="_blank"
      href="https://forms.gle/pJGzsArGDAGaqN2R8"
    >
      Send feedback

      <font-awesome-icon
        :icon="['far', 'comment-alt']"
        class="ml-2"
      />
    </a>
  </div>
</template>

<script>
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

export default {
  components: {
    FontAwesomeIcon
  }
}
</script>

<style lang="scss" scoped>
#feedback-container {
  a {
    color: black;
  }
}
</style>
