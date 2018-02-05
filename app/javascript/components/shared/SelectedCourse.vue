<template>
  <div>
    <div class="selected-course">
      <p class="select-course">Selected Course
        <i
          class="fa fa-close pull-right"
          @click="closeSidebar"
        />
      </p>
      <hr>
      <div class="actions mb-0">
        <p class="pull-left">
          <course-action
            type="tray"
            :course="course.id"
          />
          <course-action
            type="schedule"
            :course="course.id"
          />
          <course-action
            type="shareable"
            :course="course.id"
          />
        </p>
        <p class="course-history pull-right text-right">See course history</p>
      </div>

      <selected-course-details
        :course="course"
      />
      <selected-course-annotations
        :course="course"
      />
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

import CourseAction from 'components/shared/course-action'
import SelectedCourseAnnotations from './SelectedCourseAnnotations'
import SelectedCourseDetails from './SelectedCourseDetails'

export default {
  components: {
    SelectedCourseAnnotations,
    SelectedCourseDetails,
    CourseAction
  },
  props: {
    course: {
      type: Object,
      required: true
    }
  },
  methods: {
    ...mapActions('app', ['closeSidebar'])
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
