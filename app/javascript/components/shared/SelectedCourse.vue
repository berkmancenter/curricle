<template>
  <div>
    <div v-if="!trayVisible && validCourseSelected">
      <p class="select-course">Selected Course</p>
      <hr>
      <div class="row actions margin-none">
        <i
          class="fa fa-folder-open"
        />
        <i
          class="fa fa-clock-o"
        />
        <i
          class="fa fa-share-alt"
        />
        <div class="pull-right">See Course History</div>
      </div>
      <div class="row margin-none">
        <selected-course-details/>
        <selected-course-annotations/>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState } from 'vuex'
import SelectedCourseAnnotations from './SelectedCourseAnnotations'
import SelectedCourseDetails from './SelectedCourseDetails'

export default {
  components: {
    SelectedCourseAnnotations,
    SelectedCourseDetails
  },
  computed: {
    ...mapGetters('user', ['validCourseSelected']),
    ...mapState('app', ['trayVisible'])
  }
}
</script>