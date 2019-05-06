<template>
  <div
    id="sidebar"
  >
    <tray
      v-show="sidebarCurrentType === 'tray'"
    />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Tray from 'components/tray/Tray'

export default {
  components: {
    Tray
  },
  computed: {
    ...mapGetters('app', ['sidebarCurrentType'])
  }
}
</script>
