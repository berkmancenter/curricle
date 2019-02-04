<template>
  <div id="the-alert">
    <b-alert
      :show="dismissCountDown"
      fade
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

<style scoped>
#the-alert {
  height: 50px;
  left: 0;
  margin-left: auto;
  margin-right: auto;
  width: 300px;
  position: fixed;
  top: 20px;
  right: 0;
  z-index: 999;
}

div.alert {
  background-color: black;
  color: white;
  font-size: 12px;
  text-align: center;
}
</style>
