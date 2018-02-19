<template>
  <div class="row mx-0">
    <div class="col-md-9 d-flex flex-column">
      <search-form />
      <br>
      <search-results />
    </div>
    <div class="col-md-3 top-header">
      <the-sidebar />
    </div>
  </div>
</template>

<script>
import SearchForm from 'components/search/SearchForm'
import SearchResults from 'components/search/SearchResults'
import TheSidebar from 'components/TheSidebar'

export default {
  components: {
    SearchForm,
    SearchResults,
    TheSidebar
  }
}
</script>

<style type="text/css" scoped>
  .top-header {
    margin-top: 28px;
  }
</style>
