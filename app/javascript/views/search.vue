<template>
  <div>
    <div class="row">
      <div class="col-md-9">
        <basic-search />
        <br>
        <curricle-search />
      </div>
      <div class="col-md-3 sidebar">
        <tray v-if="trayVisible" />
        <selected-course v-if="validCourseSelected" />
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
import Tray from 'components/tray/tray'
import BasicSearch from 'components/BasicSearch'
import CurricleSearch from 'components/CurricleSearch'
import SelectedCourse from 'components/plan/selected-course'

export default {
  components: {
    BasicSearch,
    CurricleSearch,
    SelectedCourse,
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
