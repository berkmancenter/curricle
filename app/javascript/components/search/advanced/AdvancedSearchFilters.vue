<template>
  <div id="filter-container">
    <p class="heading">
      Filter results by:
    </p>

    <div class="row">
      <div
        v-for="facet in facets"
        :key="facet.key"
        class="col-md-3"
      >
        <advanced-search-filters-facet :facet="facet" />
      </div>
    </div>
  </div>
</template>

<script>
import AdvancedSearchFiltersFacet from './AdvancedSearchFiltersFacet'

export default {
  components: {
    AdvancedSearchFiltersFacet
  },
  data () {
    return {
      facets: [
        { key: 'academicGroups', title: 'School' },
        { key: 'departments', title: 'Department' },
        { key: 'subjects', title: 'Subject' },
        { key: 'components', title: 'Format' }
      ]
    }
  }
}
</script>

<style lang="scss" scoped>
  #filter-container {
    min-width: 400px;

    p.heading {
      color: #888;
      font-size: 13px;
    }
  }
</style>
