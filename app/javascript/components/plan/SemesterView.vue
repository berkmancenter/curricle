<template>
  <div>
    <h3>
      Plan:
    </h3>

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
import SemesterCreditHours from './SemesterViewSemesterCreditHours'

export default {
  components: {
    SemesterCreditHours
  },
  computed: {
    ...mapGetters('plan', ['sortedSemestersInSchedule', 'scheduledCoursesBySemester'])
  }
}
</script>
