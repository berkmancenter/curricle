<template>
  <div v-show="keywords && searchComplete">
    <strong>{{ results.length }} Results</strong>
    <div class="results-container">
      <curricle-search-results
        v-for="result of results"
        :key="result.id"
        :course="result"
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
