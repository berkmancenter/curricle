<template>
  <div
    id="tray-control"
    class="background-black pointer text-uppercase"
    @click="trayToggle"
  >
    Tray
    <span v-show="trayCourses.length">
      ({{ trayCourses.length }})
    </span>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters('user', ['trayCourses'])
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
  top: 30%;
  transform: rotate(-90deg);
  transform-origin: right bottom;
  z-index: 99;
}
</style>
