<template>
  <div v-if="keywords && searchComplete">
    <strong>{{ results.length }} Results</strong>
    <div class="results-container">
      <curricle-search-results
        v-for="result of results"
        :key="result.id"
        :academic_group="result.academic_group"
        :catalog_number="result.catalog_number"
        :component="result.component"
        :course_instructors="result.course_instructors"
        :description="result.course_description_long"
        :id="result.id"
        :subject="result.subject"
        :term_name="result.term_name"
        :term_year="result.term_year"
        :title="result.title"
        :units_maximum="result.units_maximum"
        :getUserCourses="getUserCourses"
        :isBelongsToUser="isBelongsToUser"
        :isMeetingBelongsToUser="isMeetingBelongsToUser"
        :meeting="result.meeting_with_tods"
        :userSchedule="result.user_schedule"
      />
    </div>
  </div>
</template>

<script>
import ApolloClient from 'apollo-client-preset'
import CurricleSearchResults from './CurricleSearchResults.vue'
import gql from 'graphql-tag'

const client = new ApolloClient()

export default {
  components: {
    CurricleSearchResults
  },
  props: {
    keywords: {
      type: Array,
      default () {
        return []
      }
    },
    getResults: {
      type: Function
    },
    getUserCourses: {
      type: Function
    },
    isBelongsToUser: {
      type: Function
    },
    isMeetingBelongsToUser: {
      type: Function
    }
  },
  data () {
    return {
      results: [],
      searchComplete: false
    }
  },
  computed: {
    keywordTexts () {
      return this.keywords.map(k => k['text'])
    }
  },
  watch: {
    keywords () {
      this.searchByKeywords()
    }
  },
  methods: {
    searchByKeywords () {
      // TODO: Add error handling for failed API calls
      if (this.keywords && this.keywords.length) {
        this.searchComplete = false

        client.query({
          query: gql`
            query CourseSearch($deluxeKeywords: [DeluxeKeywordInput]) {
              courses(deluxe_keywords: $deluxeKeywords) {
                academic_group
                catalog_number
                component
                course_description_long
                id
                subject
                term_name
                term_year
                title
                units_maximum
                course_instructors {
                  display_name
                  id
                }
              }
            }
          `,
          variables: { deluxeKeywords: this.keywords }
        })
          .then(response => {
            this.results = response.data.courses
            this.searchComplete = true
            this.getResults(this.results)
          })
      } else {
        this.results = []
      }
    }
  }
}
</script>

<style scoped>
.results-container {
  margin-top: 10px;
}
</style>
