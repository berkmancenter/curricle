<template>
  <div>
    <search-form v-if="userAuthenticated"/>
    <br>
    <search-results />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { deserializeSearch } from 'lib/util'

import SearchForm from 'components/search/SearchForm'
import SearchResults from 'components/search/SearchResults'

export default {
  components: {
    SearchForm,
    SearchResults
  },
  computed: {
    ...mapGetters('user', ['userAuthenticated'])
  },
  mounted () {
    if (this.$route.params[0]) {
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
