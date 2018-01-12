<template>
  <div class="calendar-sidebar">
    <div v-for="(courses, day) in calenderEvents">
      <strong>{{ day }}</strong>
      <div class="table-responsive">
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
				          v-if="course.meeting"
                  >
                </i>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script type="text/javascript">
  import axios from 'axios'
  export default {
    props: ['calenderEvents', 'getUserCourses', 'isMeetingBelongsToUser'],
    methods: {
      addRemoveSchedule (meetingId) {
        if(this.isMeetingBelongsToUser(meetingId)){
          axios
          .delete("/courses/remove_from_schedule", {params: {pattern_id: meetingId} })
          .then((response) => {
            this.getUserCourses(true)
          })
        }else{
          axios
          .post("/courses/add_to_schedule", {pattern_id: meetingId})
          .then((response) => {
            this.getUserCourses(true)
          })
        }
      },
    }
  }
</script>

<style type="text/css">  
   .course-list-iltem tbody tr {
    margin-bottom: 5px;
    display: table;
    width: 100%;
    vertical-align: middle;
    background: #DCDCDC;
    font-size: 12px;
    cursor: pointer;
    height: 60px;
  }
  .course-list-iltem thead {
    display: table-caption;
    width: 100%;
  }
  
  .course-list-iltem tbody { 
    border-top: 2px solid #C0C0C0;
  }
  .table td {
    vertical-align: middle !important;
  }
  .your-tray-parent {
    display: inline-block;
    width: 100%;
  }
  .your-tray-parent p span {
    float: right;
  }
  .actions {
    margin-bottom: 40px;
  }
   
  /*.fc-head-container div table thead tr th:nth-child(2), 
  .fc-head-container div table thead tr th:nth-child(8) {
    display: none;
  }*/
</style>
