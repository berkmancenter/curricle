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
            :course="theCourse.id"
          />
          <course-action
            type="schedule"
            :course="theCourse.id"
          />
          <course-action
            type="shareable"
            :course="theCourse.id"
          />
        </p>
        <p class="course-history pull-right text-right">See course history</p>
      </div>

      <selected-course-details
        :course="theCourse"
      />
      <selected-course-annotations
        :course="theCourse"
      />
    </div>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'

import CourseAction from 'components/shared/course-action'
import SelectedCourseAnnotations from 'components/shared/SelectedCourseAnnotations'
import SelectedCourseDetails from 'components/shared/SelectedCourseDetails'

export default {
  components: {
    SelectedCourseAnnotations,
    SelectedCourseDetails,
    CourseAction
  },
  props: {
    course: {
      type: [String, Number, Object],
      required: true
    }
  },
  computed: {
    ...mapState('courses', ['courses']),
    theCourse () {
      console.log('finding course object for ', this.course)
      if (typeof this.course === 'object') {
        return this.course
      }
      return this.courses[this.course]
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
