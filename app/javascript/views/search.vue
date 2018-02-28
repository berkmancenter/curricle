<template>
  <div class="row mx-0">
    <div class="col-md-9 d-flex flex-column">
      <search-form v-if="userAuthenticated"/>
      <br>
      <search-results />
    </div>
    <div class="col-md-3 top-header">
      <the-sidebar />
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { deserializeSearch } from 'lib/util'

import SearchForm from 'components/search/SearchForm'
import SearchResults from 'components/search/SearchResults'
import TheSidebar from 'components/TheSidebar'

export default {
  components: {
    SearchForm,
    SearchResults,
    TheSidebar
  },
  computed: {
    ...mapGetters('user', ['userAuthenticated'])
  },
  mounted () {
    if (this.$route.params[0]) {
      var obj = deserializeSearch(this.$route)
      if (obj) {
        this.$store.dispatch('search/populateSearchState', obj)
      }
    }
  }
}
</script>

<style type="text/css" scoped>
  .top-header {
    margin-top: 28px;
  }
</style>
