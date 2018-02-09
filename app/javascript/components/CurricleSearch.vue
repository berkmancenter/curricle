<template>
  <div v-show="keywords && searchComplete">
    <strong>{{ results.length - (showConflicts ? 0 : conflictCount) }} Results</strong>
    <span class="pull-right">
      <b-form-checkbox v-model="showConflicts">
        Show Results with Conflicts ({{ conflictCount }})
      </b-form-checkbox>
    </span>
    <div class="results-container">
      <curricle-search-results
        v-for="result of results"
        :key="result.id"
        :course="result"
        :selected="currentCourse && currentCourse.id === result.id"
        :conflicts="courseConflicts[result.id] ? courseConflicts[result.id].conflicts : []"
        :is-conflicted="courseConflicts[result.id] ? courseConflicts[result.id].hasConflict : false"
        :show-conflicts="showConflicts"
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
  data () {
    return {
      showConflicts: false
    }
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
        (o, v) => {
          var conflictArray = courseConflictsWithScheduleByDay(v, this.currentSchedule)
          o[v.id] = {
            conflicts: conflictArray,
            hasConflict: _.some(conflictArray)
          }
          return o
        },
        {} // empty object for accumulator
      )
    },
    conflictCount () {
      return _.reduce(
        this.courseConflicts,
        (tot, obj) => tot + obj.hasConflict,
        0
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
