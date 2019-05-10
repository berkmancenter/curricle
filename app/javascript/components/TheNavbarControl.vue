<template>
  <div
    id="navbar-control"
    class="background-black pointer text-uppercase"
    @click="trayClose"
  >
    Menu
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  methods: {
    ...mapActions('app', ['trayClose'])
  }
}
</script>

<style scoped>
#navbar-control {
  background-color: black;
  border-bottom-left-radius: 5px;
  border-bottom-right-radius: 5px;
  color: white;
  padding: 15px 30px;
  position: absolute;
  left: 0;
  top: 40%;
  transform: rotate(-90deg);
  transform-origin: left top;
  z-index: 99;
}
</style>
