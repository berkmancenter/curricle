<template>
  <div class="calendar-sidebar">
    <select v-model="semester">
      <option
        v-for="sem in sortedSemestersInSchedule"
        :key="sem"
      >{{ sem }}</option>
    </select>
    <div
      v-for="day in days"
      :key="day">
      <strong>{{ day }}</strong>
      <course-list
        :courses="coursesByDay[day] || [] "
      />
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
import CourseList from 'components/shared/course-list'
import _ from 'lodash'

export default {
  components: {
    CourseList
  },
  data () {
    return {
      semester: ''
    }
  },
  computed: {
    ...mapState('app', ['viewmode']),
    ...mapGetters('plan', ['scheduledCoursesBySemester', 'sortedSemestersInSchedule']),
    coursesByDay () {
      var courses = this.scheduledCoursesBySemester[this.semester] || []
      var myDays = {}

      _.each(this.days, (day, idx) => {
        myDays[day] = _.filter(courses, c => c.days[idx] && c.days[idx].length)
      })
      return myDays
    },
    days: () => ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
  },
  watch: {
    sortedSemestersInSchedule () {
      // basic logic is if the current semester no longer has semester
      // data, change to the earliest semester which has data. (We might
      // want to switch to latest instead.)

      if (!this.scheduledCoursesBySemester[this.semester]) {
        this.semester = this.sortedSemestersInSchedule[0]
      }
    }
  },
  mounted () {
    this.semester = this.sortedSemestersInSchedule && this.sortedSemestersInSchedule[0]
  }
}
</script>

<style>
</style>
