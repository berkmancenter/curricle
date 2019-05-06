<template>
  <div>
    <sidebar-list-filters class="mb-4" />

    <course-list
      :courses="filteredCourses"
      :invert="true"
    />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import CourseList from 'components/shared/CourseList'
import SidebarListFilters from './SidebarListFilters'

export default {
  components: {
    CourseList,
    SidebarListFilters
  },
  computed: {
    ...mapGetters('plan', ['filteredCourses'])
  }
}
</script>

<style scoped>
hr {
  border-color: #ccc !important;
  border-width: 1px !important;
}
</style>
