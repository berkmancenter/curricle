<template>
  <div>
    <b-alert
      :show="dismissCountDown"
      dismissible
      fade
      variant="secondary"
      @dismissed="dismissCountDown=0"
      @dismiss-count-down="countDownChanged"
    >
      {{ alertText }}
    </b-alert>
  </div>
</template>

<script>
import { mapMutations, mapState } from 'vuex'

export default {
  data () {
    return {
      dismissCountDown: 0
    }
  },
  computed: {
    ...mapState('app', ['alertText'])
  },
  watch: {
    alertText: function (newAlert, oldAlert) {
      if (newAlert !== '') {
        this.dismissCountDown = 3
      }
    }
  },
  methods: {
    ...mapMutations('app', ['SET_ALERT_TEXT']),
    countDownChanged (dismissCountDown) {
      this.dismissCountDown = dismissCountDown

      if (dismissCountDown === 0) {
        this.SET_ALERT_TEXT('')
      }
    }
  }
}
</script>
