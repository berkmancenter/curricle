<template>
  <div
    id="selected-course"
    class="p-3 col-md-10"
  >
    <div>
      <span class="float-right">
        <font-awesome-icon
          class="pointer"
          icon="times"
          @click="CLEAR_SELECTED_COURSE"
        />
      </span>
    </div>

    <div
      v-if="userAuthenticated"
      class="mb-3 row"
    >
      <div class="col">
        <course-action
          :course="course.id"
          class="course-action"
          type="tray"
        />

        <span class="font-weight-bold text-uppercase">
          <span v-if="courseIdInTray(course.id)">
            Remove from schedule
          </span>
          <span v-else>
            Add to schedule
          </span>
        </span>
      </div>
    </div>

    <selected-course-details
      :course="course"
      v-bind="$props"
    />
  </div>
</template>

<script>
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { mapActions, mapGetters, mapMutations } from 'vuex'
import CourseAction from 'components/shared/CourseAction'
import SelectedCourseDetails from './SelectedCourseDetails'

export default {
  components: {
    CourseAction,
    FontAwesomeIcon,
    SelectedCourseDetails
  },
  props: {
    course: {
      type: Object,
      required: true
    },
    userAuthenticated: {
      type: Boolean,
      required: true
    }
  },
  computed: {
    ...mapGetters('user', ['courseIdInSchedule', 'courseIdInTray'])
  },
  watch: {
    course: {
      immediate: true,
      handler: function (newCourse) {
        this.registerCourses([newCourse])
      }
    }
  },
  methods: {
    ...mapActions('courses', ['registerCourses']),
    ...mapMutations('app', ['CLEAR_SELECTED_COURSE'])
  }
}
</script>

<style lang="scss" scoped>
  #selected-course {
    background-color: #f5f5f5;
    border: 3px solid #000;
    border-radius: 3px;
    bottom: 6%; /* Footer is 5% of window height */
    left: 20%;
    max-height: 80vh;
    overflow: scroll;
    position: fixed;
    width: 60%;
    z-index: 999;
  }

  .course-action {
    display: inline-block;
    width: 20px;
  }
</style>
