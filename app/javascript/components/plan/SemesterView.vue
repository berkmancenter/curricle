<template>
  <div>
    <h3>
      Plan by Semester:
    </h3>

    <my-harvard-link
      v-if="scheduledCourses"
      :courses="scheduledCourses"
      class="my-4"
    />

    <semester-credit-hours
      v-for="semester in sortedSemestersInSchedule"
      :key="semester"
      :semester="semester"
      :courses="scheduledCoursesBySemester[semester]"
    />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import MyHarvardLink from './shared/MyHarvardLink'
import SemesterCreditHours from './SemesterViewSemesterCreditHours'

export default {
  components: {
    MyHarvardLink,
    SemesterCreditHours
  },
  computed: {
    ...mapGetters('plan', ['sortedSemestersInSchedule', 'scheduledCoursesBySemester', 'scheduledCourses'])
  }
}
</script>
