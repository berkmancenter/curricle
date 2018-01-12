<template>
  <table class="course-list-iltem table">
    <thead></thead>
    <tbody>
      <tr v-for="course in courses">
        <td>{{ course.external_course_id }}</td>
        <td>{{ course.title }}</td>            
        <td style="border-right: 5px solid #000;">
          <i
            class= "fa fa-clock-o"
            v-bind:class="{ 'user-schedule': !isMeetingBelongsToUser(course.meeting.id) }"
            @click="addRemoveSchedule(course.meeting.id)"
            >
          </i>
        </td>
      </tr>
    </tbody>
  </table>
</template>
<script type="text/javascript">
import axios from 'axios'
export default {
  props: ['courses', 'isMeetingBelongsToUser', 'getUserCourses'],
  methods: {
    addRemoveSchedule (meetingId) {
      if(this.isMeetingBelongsToUser(meetingId)){
        axios
        .delete("/courses/remove_from_schedule", {params: {pattern_id: meetingId} })
        .then((response) => {
          this.getUserCourses()
        })
      }else{
        axios
        .post("/courses/add_to_schedule", {pattern_id: meetingId})
        .then((response) => {
          this.getUserCourses()
        })
      }
    },
  }
}
</script>
