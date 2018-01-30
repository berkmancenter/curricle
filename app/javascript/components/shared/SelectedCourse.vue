<template>
  <div>
    <div
      class="selected-course"
      v-if="!trayVisible && validCourseSelected">
      <p class="select-course">Selected Course</p>
      <hr>
      <div class="actions mb-0">
        <p class="pull-left">
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
        </p>
        <p class="course-history pull-right text-right">See course history</p>
      </div>

      <selected-course-details/>
      <selected-course-annotations/>
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

<style scoped>
  .actions {
    display: inline-block;
    width: 100%;
  }

  .selected-course {
    position: relative;
  }

  p.course-history {
    font-size: 13px;
    font-weight: bold;
    cursor: not-allowed;
  }
</style>
