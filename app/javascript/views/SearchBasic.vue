<template>
  <div class="py-5">
    <h3>Search:</h3>

    <p>
      Type in a keyword to find a list of best matches.
      Use the semester selector to define and/or expand the range of your search.
    </p>

    <search-form />

    <search-results
      v-show="searchComplete"
      search-type="basic"
    />
  </div>
</template>

<script>
import { mapState } from 'vuex'
import SearchForm from 'components/search/basic/SearchForm'
import SearchResults from 'components/search/SearchResults'

export default {
  components: {
    SearchForm,
    SearchResults
  },
  computed: {
    ...mapState('search', ['searchComplete'])
  }
}
</script>
