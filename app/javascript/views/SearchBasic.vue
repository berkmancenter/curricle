<template>
  <div class="py-5">
    <h3>Search:</h3>

    <search-form />

    <search-results v-show="searchComplete" />
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
