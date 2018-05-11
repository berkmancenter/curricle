<template>
  <p class="tray-share float-right text-right">
    <span
      id="share-dropdown"
      class="pointer">
      Share&nbsp;<font-awesome-icon icon="share"/>

      <b-popover
        target="share-dropdown"
        triggers="click blur"
        placement="bottom">
        Share this link to allow others to view your schedule:
        <br>
        <span class="shared-schedule-url">
          {{ scheduleUrl }}
        </span>
      </b-popover>
    </span>

  </p>
</template>

<script>
import { mapState } from 'vuex'
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'

export default {
  components: {
    FontAwesomeIcon
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
p.tray-share {
  font-size: 13px;
  font-weight: bold;
}

.pointer {
  cursor: pointer;
}

span.shared-schedule-url {
  font-size: 13px;
  font-weight: bold;
}
</style>
