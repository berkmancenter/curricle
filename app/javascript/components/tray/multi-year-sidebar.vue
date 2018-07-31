<template>
  <div class="multi-year-sidebar">
    <div
      v-for="semester in sortedSemestersInTray.slice().reverse()"
      :key="semester">
      <strong>{{ semester }}</strong>
      <div
        class="float-right pointer"
        @click="toggleEditSemester(semester)"
        v-text="isEditing[semester] ? 'Done' : 'Edit'"/>
      <course-list
        :courses="(isEditing[semester] ? trayCoursesBySemester[semester] : scheduledCoursesBySemester[semester]) || []"
        :editable="isEditing[semester]"
        :invert="true"
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
    _.each(this.sortedSemestersInTray, s => { this.$set(this.isEditing, s, false) })
  },
  methods: {
    toggleEditSemester (sem) {
      this.isEditing[sem] = !this.isEditing[sem]
    }
  }
}
</script>

<style scoped>
.pointer {
  cursor: pointer;
}
</style>
