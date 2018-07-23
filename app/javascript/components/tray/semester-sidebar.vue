<template>
  <div class="semester-sidebar">
    <semester-selector
      mode="state"
      source="schedule"/>

    <div
      v-for="day in days"
      :key="day">
      <strong>{{ day }}</strong>
      <div
        v-show="trayCoursesByDay[day] && trayCoursesByDay[day].length"
        class="float-right"
      />
      <course-list
        :courses="isEditing[day] ? trayCoursesByDay[day] : coursesByDay[day]"
        :editable="true"
        :invert="true"
      />
    </div>
  </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from 'vuex'
import CourseList from 'components/shared/course-list'
import SemesterSelector from 'components/plan/semester-selector'
import _ from 'lodash'
import { partitionCoursesByDay } from 'lib/util'

export default {
  components: {
    CourseList,
    SemesterSelector
  },
  data () {
    return {
      isEditing: {}
    }
  },
  computed: {
    ...mapState('plan', ['semester']),
    ...mapGetters('plan', ['scheduledCoursesBySemester', 'trayCoursesBySemester', 'sortedSemestersInSchedule']),
    coursesByDay () {
      var courses = this.scheduledCoursesBySemester[this.semester] || []
      return partitionCoursesByDay(courses)
    },
    trayCoursesByDay () {
      var courses = this.trayCoursesBySemester[this.semester] || []
      return partitionCoursesByDay(courses)
    },
    days: () => ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
  },
  watch: {
    sortedSemestersInSchedule () {
      if (!this.sortedSemestersInSchedule.includes(this.semester)) {
        this.setSemester(this.sortedSemestersInSchedule[0])
      }
    }
  },
  mounted () {
    if (this.sortedSemestersInSchedule && !this.sortedSemestersInSchedule.includes(this.semester)) {
      this.setSemester(this.sortedSemestersInSchedule[0])
    }

    _.each(this.days, d => { this.$set(this.isEditing, d, false) })
  },
  methods: {
    ...mapActions('plan', ['setSemester']),
    toggleEditDay (day) {
      this.isEditing[day] = !this.isEditing[day]
    }
  }
}
</script>

<style>
</style>
