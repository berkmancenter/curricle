<template>
  <div class="row mx-0">
    <div class="col-md-9">
      <hr>
      <b-jumbotron
        header="Explore"
        lead="View Template">
        <p>Paragraph</p>

        <b-btn
          variant="primary"
          href="#">
          Button
        </b-btn>
      </b-jumbotron>
    </div>
    <div class="col-md-3 top-header">
      <tray v-if="trayVisible" />
      <selected-course v-if="validCourseSelected" />
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
import Tray from 'components/tray/tray'
import SelectedCourse from 'components/shared/SelectedCourse'

export default {
  components: {
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
