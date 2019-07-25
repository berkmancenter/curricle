<template>
  <b-button
    :id="id"
    :size="size"
    :variant="variant"
    @click="$refs.tooltip.$emit('close')"
  >
    Share Schedule

    <b-popover
      :target="id"
      placement="bottom"
      triggers="click blur"
    >
      Share this link to allow others to view your schedule:
      <br>
      <span class="shared-schedule-url">
        {{ scheduleUrl }}
      </span>
    </b-popover>

    <b-popover
      ref="tooltip"
      :target="id"
      placement="bottom"
      triggers="hover"
    >
      Generates a unique<br>
      URL of your schedule<br>
      that you can share with<br>
      advisers and friends
    </b-popover>
  </b-button>
</template>

<script>
import { mapState } from 'vuex'

export default {
  props: {
    id: {
      type: String,
      required: true
    },
    size: {
      type: String,
      default: null
    },
    variant: {
      type: String,
      default: 'dark'
    }
  },
  computed: {
    ...mapState('user', ['scheduleToken']),
    scheduleUrl () {
      return `http://${window.location.host}/#/shared-schedule/${this.scheduleToken}`
    }
  }
}
</script>

<style scoped>
span.shared-schedule-url {
  font-size: 13px;
  font-weight: bold;
}
</style>
