<template>
  <div
    v-if="course.id"
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

    <div class="mb-3 row">
      <div class="col">
        <template v-if="userAuthenticated && !courseIdImported(course.id)">
          <course-action
            :course-id="course.id"
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
        </template>

        <template v-else>
          &nbsp;
        </template>
      </div>
    </div>

    <selected-course-details
      v-if="course.id"
      :course="course"
      v-bind="$props"
    />
  </div>
</template>

<script>
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { mapActions, mapGetters, mapMutations } from 'vuex'
import { transformSchedule } from 'lib/util'
import COURSE_QUERY from 'graphql/Course.gql'
import CourseAction from 'components/shared/CourseAction'
import SelectedCourseDetails from './SelectedCourseDetails'

export default {
  apollo: {
    course: {
      query: COURSE_QUERY,
      variables () {
        return {
          id: this.courseId
        }
      }
    }
  },
  components: {
    CourseAction,
    FontAwesomeIcon,
    SelectedCourseDetails
  },
  props: {
    courseId: {
      type: String,
      required: true
    },
    userAuthenticated: {
      type: Boolean,
      required: true
    }
  },
  data () {
    return {
      course: {}
    }
  },
  computed: {
    ...mapGetters('user', ['courseIdInSchedule', 'courseIdInTray', 'courseIdImported'])
  },
  watch: {
    course: {
      immediate: true,
      handler: function (newCourse) {
        newCourse.schedule = transformSchedule(newCourse)

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
