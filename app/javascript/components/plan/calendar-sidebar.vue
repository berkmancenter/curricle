<template>
  <div class="calendar-sidebar">
    <div v-for="(courses, day) in calendarEvents">
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
                  v-bind:class="{ 'user-schedule': !userCoursesScheduleIds.includes(course.meeting_with_tods.id) }"
                  @click="addRemoveSchedule(course.meeting_with_tods.id)"
				          v-if="course.meeting_with_tods"
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
import { mapState, mapGetters } from 'vuex'

export default {
  computed: {
    ...mapState('app',['viewmode']),
    ...mapState('user', ['userCoursesScheduleIds']),
    ...mapGetters('user',['coursesByDate', 'coursesByYear', 'courseIds']),
    calendarEvents () { return this.viewmode == 'multi-year' ? this.coursesByYear : this.coursesByDate }
  },
  methods: {
    addRemoveSchedule: function(meetingId){
      this.$store.dispatch('user/addRemoveUserSchedule', meetingId)
    }
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
