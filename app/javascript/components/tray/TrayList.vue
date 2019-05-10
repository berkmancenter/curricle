<template>
  <div>
    <tray-list-semester
      v-for="semester in activeSemestersInTray"
      :key="semester"
      :semester="semester"
      :courses="trayCoursesBySemester[semester]"
      class="mb-5"
    />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import TrayListSemester from './TrayListSemester.vue'

export default {
  components: {
    TrayListSemester
  },
  computed: {
    ...mapGetters('plan', ['sortedSemestersInTray', 'trayCoursesBySemester']),
    ...mapGetters('search', ['isPastSemester']),
    activeSemestersInTray () {
      return this.sortedSemestersInTray.filter(semester => !this.pastSemester(semester))
    }
  },
  methods: {
    pastSemester (semester) {
      const [termName, termYear] = semester.split(' ')

      return this.isPastSemester(termName, termYear)
    }
  }
}
</script>
