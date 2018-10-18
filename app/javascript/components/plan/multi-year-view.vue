<template>
  <div class="mt-5">
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
