<template>
  <div v-show="keywords && searchComplete">
    <strong>{{ results.length }} Results</strong>
    <div class="results-container">
      <curricle-search-results
        v-for="result of results"
        :key="result.id"
        :course="result"
        :selected="currentCourse && currentCourse.id === result.id"
        :conflicts="courseConflicts[result.id].conflicts"
        :is-conflicted="courseConflicts[result.id].hasConflict"
      />
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState } from 'vuex'
import _ from 'lodash'
import CurricleSearchResults from 'components/CurricleSearchResults'
import { scheduleMakeDescriptor, courseConflictsWithScheduleByDay } from 'lib/util'

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
    courseConflicts () {
      return _.reduce(
        this.results,
        (o, v, k) => {
          var conflictArray = courseConflictsWithScheduleByDay(v, this.currentSchedule)
          o[k] = {
            conflicts: conflictArray,
            hasConflict: _.some(conflictArray)
          }
          return o
        },
        {} // empty object for accumulator
      )
    },
    keywordTexts () {
      return this.keywords.map(k => k['text'])
    }
  }
}
</script>

<style scoped>
.results-container {
  margin-top: 10px;
}
</style>
