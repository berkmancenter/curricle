<template>
  <div>
    <div
      class="selected-course"
      v-if="!trayVisible && validCourseSelected">
      <p class="select-course">Selected Course
        <i
          class="fa fa-close pull-right"
          @click="selectCourse(null)"
        />
      </p>
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

      <selected-course-details
        :course="currentCourse"
      />
      <selected-course-annotations
        :course="currentCourse"
      />
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState, mapActions } from 'vuex'
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
  },
  methods: {
    ...mapActions('user', ['selectCourse'])
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

  .fa.fa-close {
    padding-right: 0.5em;
  }

  .fa.fa-close:hover {
    color: gray;
  }
</style>
