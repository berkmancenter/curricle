<template>
  <div class="semester-sidebar">
    <select
      v-model="curSemester"
      @change="changeSemester($data)">
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
        v-show="trayCoursesByDay[day] && trayCoursesByDay[day].length"
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
import { partitionCoursesByDay } from 'lib/util'

export default {
  components: {
    CourseList
  },
  data () {
    return {
      curSemester: '',
      isEditing: {}
    }
  },
  computed: {
    ...mapState('app', ['viewmode', 'semester']),
    ...mapGetters('plan', ['scheduledCoursesBySemester', 'trayCoursesBySemester', 'sortedSemestersInSchedule']),
    coursesByDay () {
      var courses = this.scheduledCoursesBySemester[this.curSemester] || []
      return partitionCoursesByDay(courses)
    },
    trayCoursesByDay () {
      var courses = this.trayCoursesBySemester[this.curSemester] || []
      return partitionCoursesByDay(courses)
    },
    days: () => ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
  },
  watch: {
    sortedSemestersInSchedule () {
      // basic logic is if the current semester no longer has semester
      // data, change to the earliest semester which has data. (We might
      // want to switch to latest instead.)

      if (!this.scheduledCoursesBySemester[this.curSemester]) {
        this.curSemester = this.sortedSemestersInSchedule[0]
      } else {
        this.curSemester = this.semester
      }
    },
    semester (s) {
      this.curSemester = s
    }
  },
  mounted () {
    if (!this.semester && this.sortedSemestersInSchedule) {
      this.$store.commit('app/SET_SEMESTER', this.sortedSemestersInSchedule[0])
    } else {
      this.curSemester = this.semester
    }
    _.each(this.days, d => { this.$set(this.isEditing, d, false) })
  },
  methods: {
    toggleEditDay (day) {
      this.isEditing[day] = !this.isEditing[day]
    },
    changeSemester (val) {
      this.$store.commit('app/SET_SEMESTER', val.curSemester)
    }
  }
}
</script>

<style>
</style>
