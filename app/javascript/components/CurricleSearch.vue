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
        :user-schedule="result.user_schedule"
      />
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState } from 'vuex'
import CurricleSearchResults from 'components/CurricleSearchResults'

export default {
  components: {
    CurricleSearchResults
  },
  computed: {
    ...mapGetters('search', { keywords: 'activeKeywords' }),
    ...mapState('search', ['searchComplete', 'results']),
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
