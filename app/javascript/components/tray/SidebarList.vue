<template>
  <div>
    <hr>

    <sidebar-list-filters/>

    <course-list :courses="filteredCourses"/>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import CourseList from 'components/shared/course-list'
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
