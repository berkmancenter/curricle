<template>
  <div v-if="keyword && searchComplete">
    <strong>{{ results.length }} Results for "{{ keyword }}"</strong>
    <div class="results-container">
      <curricle-search-results
        v-for="result of results"
        :key="result.id"
        :academic_group="result.academic_group"
        :catalog_number="result.catalog_number"
        :component="result.component"
        :description="result.course_description_long"
        :id="result.id"
        :subject="result.subject"
        :term_name="result.term_name"
        :term_year="result.term_year"
        :title="result.title"
        :units_maximum="result.units_maximum"
      />
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import CurricleSearchResults from './CurricleSearchResults.vue'

export default {
  components: {
    CurricleSearchResults
  },
  props: {
    keyword: {
      type: String,
      default: ''
    }
  },
  data () {
    return {
      results: [],
      searchComplete: false
    }
  },
  watch: {
    keyword () {
      this.searchByKeyword()
    }
  },
  methods: {
    searchByKeyword () {
      // TODO: Add error handling for failed API calls
      if (this.keyword) {
        this.searchComplete = false
        axios.get('/courses/search?keyword=' + this.keyword)
          .then(response => {
            this.results = response.data
            this.searchComplete = true
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
