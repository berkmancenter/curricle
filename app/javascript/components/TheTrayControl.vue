<template>
  <div
    id="tray-control"
    class="background-black pointer text-uppercase"
    @click="trayToggle"
  >
    Schedule
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  methods: {
    ...mapActions('app', ['trayToggle'])
  }
}
</script>

<style scoped>
#tray-control {
  background-color: black;
  border-top-left-radius: 5px;
  border-top-right-radius: 5px;
  color: white;
  padding: 15px 30px;
  position: absolute;
  right: 0;
  top: 30%;
  transform: rotate(-90deg);
  transform-origin: right bottom;
  z-index: 99;
}
</style>
