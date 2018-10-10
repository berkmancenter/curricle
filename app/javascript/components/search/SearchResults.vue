<template>
  <div
    v-show="keywords && searchComplete"
    class="mt-5">
    <div class="clearfix">
      <div
        class="float-left"
        style="width: 28%;">
        <strong>{{ resultsTotalCount }} results</strong>
      </div>
      <div class="float-left">
        <search-results-sort/>
      </div>
      <div class="float-right text-right">
        <b-form-checkbox v-model="showConflicts">
          show results with conflicts ({{ conflictCount }})
        </b-form-checkbox>
      </div>
    </div>

    <div class="results mt-4">
      <search-result-row
        v-for="result of results"
        :key="result.id"
        :course="result"
        :selected="currentCourse && currentCourse.id === result.id"
        :conflicts="courseConflicts[result.id] ? courseConflicts[result.id].conflicts : []"
        :is-conflicted="courseConflicts[result.id] ? courseConflicts[result.id].hasConflict : false"
        :show-conflicts="showConflicts"
      />

      <div
        v-show="resultsMoreAvailable"
        class="text-center my-4">
        <b-button
          class="pointer"
          variant="secondary"
          @click="searchAgain">
          More Results
        </b-button>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState } from 'vuex'
import _ from 'lodash'
import SearchResultRow from './SearchResultRow'
import SearchResultsSort from './SearchResultsSort'
import { scheduleMakeDescriptor, courseConflictsWithScheduleByDay } from 'lib/util'

export default {
  components: {
    SearchResultRow,
    SearchResultsSort
  },
  data () {
    return {
      showConflicts: false
    }
  },
  computed: {
    ...mapGetters('search', { keywords: 'activeKeywords' }),
    ...mapState('search', ['searchComplete', 'results', 'resultsMoreAvailable', 'resultsTotalCount']),
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
  },
  methods: {
    searchAgain () {
      this.$store.dispatch('search/runSearchAgain')
    }
  }
}
</script>
