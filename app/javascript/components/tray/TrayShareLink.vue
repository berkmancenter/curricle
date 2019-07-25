<template>
  <div class="text-center">
    <b-button
      id="share-schedule-button"
      class="w-100"
      variant="light"
    >
      Share Schedule
    </b-button>

    <b-popover
      target="share-schedule-button"
      triggers="click blur"
      placement="bottom"
    >
      Share this link to allow others to view your schedule:
      <br>
      <span class="shared-schedule-url">
        {{ scheduleUrl }}
      </span>
    </b-popover>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
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
