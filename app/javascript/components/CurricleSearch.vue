<template>
  <div v-show="keywords && searchComplete">
    <strong>{{ results.length }} Results</strong>
    <div class="results-container">
      <curricle-search-results
        v-for="result of results"
        :key="result.id"
        :course="result"
        :selected="currentCourse && currentCourse.id === result.id"
        :conflicted="hasConflict(result, currentSchedule)"
      />
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState } from 'vuex'
import CurricleSearchResults from 'components/CurricleSearchResults'
import { scheduleMakeDescriptor, courseConflictsWithSchedule } from 'lib/util'

export default {
  components: {
    CurricleSearchResults
  },
  computed: {
    ...mapGetters('search', { keywords: 'activeKeywords' }),
    ...mapState('search', ['searchComplete', 'results']),
    ...mapGetters('app', ['currentCourse']),
    ...mapGetters('plan', ['scheduledCourses']),
    currentSchedule () {
      return scheduleMakeDescriptor(this.scheduledCourses)
    },
    keywordTexts () {
      return this.keywords.map(k => k['text'])
    }
  },
  methods: {
    hasConflict: (course, schedule) => courseConflictsWithSchedule(course, schedule)
  }
}
</script>

<style scoped>
.results-container {
  margin-top: 10px;
}
</style>
