<template>
  <div>
    <p class="heading">Filter results:</p>

    <div class="row">
      <div
        class="col-md-3"
        v-for="facet in facets"
        :key="facet.key">
        <advanced-search-filters-facet :facet="facet"/>
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
        { key: 'academic_groups', title: 'School' },
        { key: 'departments', title: 'Department' },
        { key: 'subjects', title: 'Subject' },
        { key: 'components', title: 'Component' }
      ]
    }
  }
}
</script>

<style scoped>
  p.heading {
    color: #888;
    font-size: 13px;
  }
</style>
