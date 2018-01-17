<template>
  <table class="course-list-iltem table">
    <thead></thead>
    <tbody>
      <tr v-for="course in trayCourses">
        <td>{{ course.external_course_id }}</td>
        <td>{{ course.title }}</td>            
        <td style="border-right: 5px solid #000;">
          <i
            class= "fa fa-clock-o"
            v-bind:class="{ 'user-schedule': !userCoursesScheduleIds.includes(course.meeting_with_tods.id) }"
            @click="addRemoveSchedule(course.meeting_with_tods.id)"
            v-if="course.meeting_with_tods"
            >
          </i>
        </td>
      </tr>
    </tbody>
  </table>
</template>
<script type="text/javascript">
import axios from 'axios'
import { mapState, mapGetters } from 'vuex'

export default {
  computed: {
    ...mapState('user',['userCoursesScheduleIds']),
    ...mapGetters('user', ['trayCourses']),
  },
  methods: {
    addRemoveSchedule: function(meetingId){
      this.$store.dispatch('user/addRemoveUserSchedule', meetingId)
    }
  }
}
</script>
