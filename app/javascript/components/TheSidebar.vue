<template>
  <div id="sidebar">
    <div class="sidebar-inner">
      <tray
        v-show="sidebarCurrentType==='tray'"
      />
      <selected-course
        v-if="sidebarCurrentType==='course'"
        :course="sidebarCurrentContext"
      />
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Tray from 'components/tray/tray'
import SelectedCourse from 'components/shared/SelectedCourse'

export default {
  components: {
    Tray,
    SelectedCourse
  },
  computed: {
    ...mapGetters('app', ['sidebarCurrentType', 'sidebarCurrentContext'])
  }
}
</script>

<style>
#sidebar {
  position: fixed;
  margin-right: 2em;
  margin-left: 2em;
  height: calc(100% - 100px); /* Fix to prevent annotation container from being cut off */
  width: 300px;
  overflow: hidden;
}
.sidebar-inner {
  overflow-y: auto;
  height: 100%;
}
</style>
