<template>
  <div
    class="results-container"
    v-show="keywords && searchComplete">
    <div class="clearfix">
      <div class="pull-left">
        <strong>{{ results.length - (showConflicts ? 0 : conflictCount) }} Results</strong>
      </div>
      <div class="pull-right text-right">
        <b-form-checkbox v-model="showConflicts">
          Show Results with Conflicts ({{ conflictCount }})
        </b-form-checkbox>
      </div>
    </div>

    <div class="results">
      <curricle-search-results
        v-for="result of results"
        :key="result.id"
        :course="result"
        :selected="currentCourse && currentCourse.id === result.id"
        :conflicts="courseConflicts[result.id] ? courseConflicts[result.id].conflicts : []"
        :is-conflicted="courseConflicts[result.id] ? courseConflicts[result.id].hasConflict : false"
        :show-conflicts="showConflicts"
      />

      <div
        class="text-center my-4"
        v-show="resultsMoreAvailable">
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
    ...mapState('search', ['searchComplete', 'results', 'resultsMoreAvailable']),
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
      this.$store.dispatch('search/runKeywordSearchAgain')
    }
  }
}
</script>

<style scoped>
.results-container {
  flex-flow: column;
  display: flex;
}

.results {
  overflow: auto;
}

.pointer {
  cursor: pointer;
}
</style>
