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
            v-bind:class="{ 'user-schedule': !courseIds[course.meeting_with_tods.id] }"
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
import { mapState } from 'vuex'

export default {
  computed: {
      ...mapState('user',['trayCourses', 'courseIds']),
  },
  watch: {
    trayCourses () {
      console.log(this.trayCourses)
      console.log(this.courseIds)
    }
  },
  methods: {
    addRemoveSchedule (meetingId) {
      if(this.courseIds[meetingId]){
        axios
        .delete("/courses/remove_from_schedule", {params: {pattern_id: meetingId} })
        .then((response) => {
          this.$store.dispatch("user/getCourses");
        })
      }else{
        axios
        .post("/courses/add_to_schedule", {pattern_id: meetingId})
        .then((response) => {
          this.$store.dispatch("user/getCourses");
        })
      }
    },
  }
}
</script>
