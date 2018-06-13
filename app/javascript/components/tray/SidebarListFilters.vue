<template>
  <div class="mb-2">
    <div
      class="clearfix pointer"
      @click="showFilters = !showFilters">
      <div class="filters-header">
        Filter: {{ activeFilterLabel }}
      </div>

      <div class="filters-header text-center">
        <font-awesome-icon
          v-show="!showFilters"
          icon="caret-down"/>
        <font-awesome-icon
          v-show="showFilters"
          icon="caret-up"/>
      </div>
    </div>

    <div v-show="showFilters">
      <department-selector/>

      <br>

      <semester-selector
        mode="filter"
        source="tray"
      />
    </div>

    <hr class="mt-2">
  </div>
</template>

<script>
import { mapState } from 'vuex'
import DepartmentSelector from 'components/plan/department-selector'
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'
import SemesterSelector from 'components/plan/semester-selector'

export default {
  components: {
    DepartmentSelector,
    FontAwesomeIcon,
    SemesterSelector
  },
  data () {
    return {
      showFilters: false
    }
  },
  computed: {
    ...mapState('plan', ['filters']),
    activeFilterLabel () {
      let activeFilters = []

      if (this.filters.department) {
        activeFilters.push(this.filters.department)
      }

      if (this.filters.semester) {
        activeFilters.push(this.filters.semester)
      }

      if (activeFilters.length) {
        return activeFilters.join(', ')
      } else {
        return 'Show All'
      }
    }
  }
}
</script>

<style scoped>
.filters-header {
  font-size: 14px;
  font-weight: bold;
}

.pointer {
  cursor: pointer;
}

hr {
  border-color: #ccc !important;
  border-width: 1px !important;
}
</style>
