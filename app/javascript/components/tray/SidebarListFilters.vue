<template>
  <div>
    <department-selector />

    <semester-selector
      mode="filter"
      source="tray"
    />
  </div>
</template>

<script>
import { mapState } from 'vuex'
import DepartmentSelector from 'components/plan/department-selector'
import SemesterSelector from 'components/plan/semester-selector'

export default {
  components: {
    DepartmentSelector,
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
