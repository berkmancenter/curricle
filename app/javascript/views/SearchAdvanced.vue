<template>
  <div class="py-5">
    <h3>Advanced Search:</h3>

    <p>
      Narrow down your search to specific parts of course catalog entries and filter your results by additional parameters.
    </p>

    <search-form v-if="userAuthenticated" />

    <search-results
      v-show="searchComplete"
      search-type="advanced"
    />
  </div>
</template>

<script>
import { mapGetters, mapState } from 'vuex'
import { deserializeSearch } from 'lib/util'

import SearchForm from 'components/search/advanced/SearchForm'
import SearchResults from 'components/search/SearchResults'

export default {
  components: {
    SearchForm,
    SearchResults
  },
  computed: {
    ...mapGetters('user', ['userAuthenticated']),
    ...mapState('search', ['searchComplete'])
  },
  mounted () {
    if (this.$route.params.pathMatch) {
      var obj = deserializeSearch(this.$route)
      if (obj) {
        this.$store.dispatch('search/populateSearchState', obj)
          .then(
            () => this.$store.dispatch('search/runKeywordSearch')
          )
      }
    }
  }
}
</script>
