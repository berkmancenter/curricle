<template>
  <div
    id="sidebar"
    class="h-100">
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
