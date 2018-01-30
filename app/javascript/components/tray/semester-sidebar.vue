<template>
  <div class="semester-sidebar">
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
      <div
        v-if="trayCoursesByDay[day] && trayCoursesByDay[day].length"
        v-text="isEditing[day] ? 'Done' : 'Edit'"
        @click="toggleEditDay(day)"
        class="pull-right"
      />
      <course-list
        :courses="isEditing[day] ? trayCoursesByDay[day] : coursesByDay[day]"
        :editable="isEditing[day]"
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
      semester: '',
      isEditing: {}
    }
  },
  computed: {
    ...mapState('app', ['viewmode']),
    ...mapGetters('plan', ['scheduledCoursesBySemester', 'trayCoursesBySemester', 'sortedSemestersInSchedule']),
    coursesByDay () {
      var courses = this.scheduledCoursesBySemester[this.semester] || []
      var myDays = {}

      _.each(this.days, (day, idx) => {
        myDays[day] = _.filter(courses, c => c.days[idx] && c.days[idx].length)
      })
      return myDays
    },
    trayCoursesByDay () {
      var courses = this.trayCoursesBySemester[this.semester] || []
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
    _.each(this.days, d => { this.$set(this.isEditing, d, false) })
  },
  methods: {
    toggleEditDay (day) {
      this.isEditing[day] = !this.isEditing[day]
    }
  }
}
</script>

<style>
</style>
