<template>
  <div>
    <div v-if="!trayVisible && validCourseSelected">
      <p class="select-course">Selected Course</p>
      <hr>
      <div class="row actions mx-0">
        <course-action
          type="tray"
          :course="currentCourse.id"
        />
        <course-action
          type="schedule"
          :course="currentCourse.id"
        />
        <course-action
          type="shareable"
          :course="currentCourse.id"
        />
        <div class="pull-right">See Course History</div>
      </div>
      <div class="row mx-0">
        <selected-course-details/>
        <selected-course-annotations/>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState } from 'vuex'
import CourseAction from 'components/shared/course-action'
import SelectedCourseAnnotations from './SelectedCourseAnnotations'
import SelectedCourseDetails from './SelectedCourseDetails'

export default {
  components: {
    SelectedCourseAnnotations,
    SelectedCourseDetails,
    CourseAction
  },
  computed: {
    ...mapState('user', ['currentCourse']),
    ...mapGetters('user', ['validCourseSelected']),
    ...mapState('app', ['trayVisible'])
  }
}
</script>
