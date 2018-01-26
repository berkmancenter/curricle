<template>
  <table class="course-list-iltem table">
    <thead/>
    <tbody>
      <tr
        v-for="course in trayCourses"
        :key="course.id">
        <td>{{ course.external_course_id }}</td>
        <td>{{ course.title }}</td>
        <td style="border-right: 5px solid #000;">
          <course-action
            type="schedule"
            :course="course.id"
          />
        </td>
      </tr>
    </tbody>
  </table>
</template>

<script>
import { mapGetters } from 'vuex'
import CourseAction from 'components/shared/course-action'

export default {
  components: {
    CourseAction
  },
  computed: {
    ...mapGetters('user', ['trayCourses'])
  }
}
</script>
