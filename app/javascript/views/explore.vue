<template>
  <div>
    <div class="row">
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
      <div class="col-md-3 sidebar">
        <tray v-if="trayVisible" />
        <selected-course v-if="validCourseSelected" />
      </div>
    </div>
  </div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
import Tray from 'components/tray/tray'
import SelectedCourse from 'components/plan/selected-course'

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
  .sidebar{
    margin-top: 28px;
  }
</style>
