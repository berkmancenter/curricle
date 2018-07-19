<template>
  <div
    id="sidebar">
    <tray
      v-show="sidebarCurrentType==='tray'"
    />

    <selected-course
      v-if="sidebarCurrentType==='course'"
      :course="sidebarCurrentContext"
    />
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
