<template>
  <div
    id="tray-control"
    :class="{ 'd-none': isTrayVisible }"
    class="background-black pointer text-uppercase"
    @click="trayToggle">
    Tray
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters('app', ['isTrayVisible'])
  },
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
  top: 50%;
  transform: translateX(71px) rotate(-90deg);
  transform-origin: left center;
  z-index: 99;
}
</style>
