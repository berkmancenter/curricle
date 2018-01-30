<template>
  <div>
    <semester-credit-hours
      v-for="semester in sortedSemestersInSchedule"
      :semester="semester"
      :key="semester"
      :courses="scheduledCoursesBySemester[semester]"
    />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

import SemesterCreditHours from 'components/plan/semester-credit-hours'

export default {
  components: {
    SemesterCreditHours
  },
  computed: {
    ...mapGetters('plan', ['sortedSemestersInSchedule', 'scheduledCoursesBySemester'])
  }
}
</script>

<style>

</style>
