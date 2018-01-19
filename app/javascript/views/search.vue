<template>
  <div>
    <div class="row">
      <div class="col-md-8">
        <basic-search />
        <br>
        <curricle-search />
      </div>
      <div class="col-md-4 sidebar">
        <tray v-if="trayVisible" />
        <selected-course v-if="validCourseSelected" />
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
import Tray from '../components/tray/tray.vue'
import BasicSearch from '../components/BasicSearch.vue'
import CurricleSearch from '../components/CurricleSearch.vue'

export default {
  components: {
    BasicSearch,
    CurricleSearch,
    Tray
  },

  computed: {
    ...mapState('app', ['trayVisible']),
    ...mapGetters('user', ['validCourseSelected'])
  }
}
</script>

<style type="text/css">
  .sidebar{
    margin-top: 28px;
  }
</style>
