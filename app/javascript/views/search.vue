<template>
  <div class="row mx-0">
    <div class="col-md-9">
      <basic-search />
      <br>
      <curricle-search />
    </div>
    <div class="col-md-3 top-header">
      <tray v-show="trayVisible" />
      <selected-course v-show="validCourseSelected" />
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
import Tray from 'components/tray/tray'
import BasicSearch from 'components/BasicSearch'
import CurricleSearch from 'components/CurricleSearch'
import SelectedCourse from 'components/shared/SelectedCourse'

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
  .top-header {
    margin-top: 28px;
  }
</style>
