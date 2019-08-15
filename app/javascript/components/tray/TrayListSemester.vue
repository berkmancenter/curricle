<template>
  <div>
    <p class="text-uppercase font-weight-bold">
      {{ semester }}
    </p>

    <div
      v-for="course in sortedCourses"
      :key="course.id"
      class="d-table mb-3 pointer"
      @click="selectCourse(course)"
    >
      <div class="d-table-row">
        <div class="d-table-cell pr-2">
          <course-action
            :course-id="course.id"
            :invert="true"
            type="tray"
          />
        </div>

        <div class="d-table-cell">
          <truncate
            :length="30"
            :text="course.title"
            :class="courseIdStyles(course.id)"
            class="text-uppercase"
            clamp="..."
            less=" "
          />

          <class-meeting-time
            :condensed="true"
            :course="course"
            :tbd-icon="false"
            :class="courseIdStyles(course.id)"
            class="meeting-time text-uppercase font-weight-normal"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'
import _ from 'lodash'
import ClassMeetingTime from 'components/shared/ClassMeetingTime'
import CourseAction from 'components/shared/CourseAction.vue'
import truncate from 'vue-truncate-collapsed'

export default {
  components: {
    ClassMeetingTime,
    CourseAction,
    truncate
  },
  props: {
    courses: {
      type: Array,
      required: true
    },
    semester: {
      type: String,
      required: true
    }
  },
  computed: {
    ...mapGetters('user', ['courseIdStyles']),
    sortedCourses () {
      return _.sortBy(this.courses, [function (course) {
        const startTime = course.courseMeetingPatterns[0].meetingTimeStartTod
        let startingHour
        let sortPosition

        if (!startTime) {
          startingHour = 0
        } else {
          startingHour = startTime.split(':')[0]
        }

        if (course.courseMeetingPatterns[0].meetsOnMonday) {
          sortPosition = 1
        } else if (course.courseMeetingPatterns[0].meetsOnTuesday) {
          sortPosition = 2
        } else if (course.courseMeetingPatterns[0].meetsOnWednesday) {
          sortPosition = 3
        } else if (course.courseMeetingPatterns[0].meetsOnThursday) {
          sortPosition = 4
        } else if (course.courseMeetingPatterns[0].meetsOnFriday) {
          sortPosition = 5
        } else {
          sortPosition = 0
        }

        return sortPosition + (startingHour / 100)
      }])
    }
  },
  methods: {
    ...mapActions('app', ['selectCourse'])
  }
}
</script>

<style lang="scss" scoped>
.schedule-course {
  font-style: normal;

  &.meeting-time {
    color: #ccc;
  }
}
</style>
