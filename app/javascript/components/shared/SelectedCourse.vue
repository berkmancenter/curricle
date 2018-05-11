<template>
  <div>
    <div class="selected-course">
      <p class="select-course">Selected Course
        <font-awesome-icon
          class="pointer float-right"
          icon="times"
          @click="closeSidebar"/>
      </p>
      <hr>
      <div
        v-if="userAuthenticated"
        class="actions mb-0">
        <p class="float-left">
          <course-action
            :course="theCourse.id"
            type="tray"/>
          <course-action
            :course="theCourse.id"
            type="schedule"/>
        </p>
        <p class="course-history float-right text-right">See course history</p>
      </div>

      <selected-course-details
        :course="theCourse"
      />
      <selected-course-annotations
        v-if="userAuthenticated"
        :course="theCourse"/>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from 'vuex'

import CourseAction from 'components/shared/course-action'
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'
import SelectedCourseAnnotations from 'components/shared/SelectedCourseAnnotations'
import SelectedCourseDetails from 'components/shared/SelectedCourseDetails'

export default {
  components: {
    SelectedCourseAnnotations,
    SelectedCourseDetails,
    CourseAction,
    FontAwesomeIcon
  },
  props: {
    course: {
      type: [String, Number, Object],
      required: true
    }
  },
  computed: {
    ...mapState('courses', ['courses']),
    ...mapGetters('user', ['userAuthenticated']),
    theCourse () {
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

  .pointer {
    cursor: pointer;
  }
</style>
