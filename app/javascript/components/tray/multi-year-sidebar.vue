<template>
  <div class="multi-year-sidebar">
    <div
      v-for="semester in sortedSemestersInTray.slice().reverse()"
      :key="semester">
      <strong>{{ semester }}</strong>
      <div
        v-text="isEditing[semester] ? 'Done' : 'Edit'"
        @click="toggleEditSemester(semester)"
        class="pull-right"
      />
      <course-list
        :courses="(isEditing[semester] ? trayCoursesBySemester[semester] : scheduledCoursesBySemester[semester]) || []"
        :editable="isEditing[semester]"
      />
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
import CourseList from 'components/shared/course-list'
import _ from 'lodash'

export default {
  components: {
    CourseList
  },
  data () {
    return {
      isEditing: {}
    }
  },
  computed: {
    ...mapState('app', ['viewmode']),
    ...mapGetters('plan', ['scheduledCoursesBySemester', 'trayCoursesBySemester', 'sortedSemestersInTray'])
  },
  mounted () {
    _.each(this.sortedSemestersInTray, d => { this.$set(this.isEditing, d, false) })
  },
  methods: {
    toggleEditSemester (sem) {
      this.isEditing[sem] = !this.isEditing[sem]
    }
  }
}
</script>

<style>
</style>
