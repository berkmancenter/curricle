<template>
  <div class="calendar-sidebar">
    <div
      v-for="semester in sortedSemestersInSchedule.slice().reverse()"
      :key="semester">
      <strong>{{ semester }}</strong>
      <course-list
        :courses="scheduledCoursesBySemester[semester] || []"
      />
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
import CourseList from 'components/shared/course-list'

export default {
  components: {
    CourseList
  },
  computed: {
    ...mapState('app', ['viewmode']),
    ...mapGetters('plan', ['scheduledCoursesBySemester', 'sortedSemestersInSchedule'])
  }
}
</script>

<style>
</style>
