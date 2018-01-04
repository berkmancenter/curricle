<template>
  <div class="table-responsive">
    <table class="course-list-iltem table">
      <thead></thead>
      <tbody>
        <tr v-for="list in lists" @click="selectItem(list)">
          <td>{{ list.external_course_id }}</td>
          <td style = "width: 12em;">{{ list.course_description }}</td>
          <td>{{ list.academic_group }} <br> {{ list.subject }}</td>
          <td>{{ list.term_name }} <br> {{ list.units_maximum }} units</td>
          <!-- <td v-html="list.course_description_long" style = "width: 16em; text-align: justify;"/> -->
          <td style = "width: 16em; text-align: justify;">
            <truncate class="course_description"  clamp="..." :length="50" less="Show Less" type="html" :text="list.course_description_long"></truncate>

          </td>
          <td>4 pm to 6pm<br> 9 am to 10 pm</td>
          <td>
            <span>M<img src=""></span>
            <br>
            <span>W<img src=""></span>
          </td>          
          <td style="border-right: 5px solid #000; position: relative; font-size: 24px;"><i class= "fa fa-clock-o" v-bind:class="{ 'user-schedule': !isMeetingBelongsToUser(list.meeting.id) }" v-if="list.meeting" @click="addRemoveSchedule(list.meeting.id)"></i></td>
          <span class= "check_box"><input type= "checkbox" name ="" value= ""></span>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script type="text/javascript">
  import axios from 'axios'
  import truncate from 'vue-truncate-collapsed';
  export default {
    props: ['selectedPlan', 'lists', 'isMeetingBelongsToUser', "fetchUserCourses"],
    components: {
      'truncate': truncate
    },
    methods: {
      selectItem: function (value) {
        this.selectedPlan(value)
      },
      addRemoveSchedule: function(meetingId){
        if(this.isMeetingBelongsToUser(meetingId)){
          axios
          .delete("/courses/remove_from_schedule", {params: {pattern_id: meetingId} })
          .then((response) => {
            this.fetchUserCourses()
          })
        }else{
          axios
          .post("/courses/add_to_schedule", {pattern_id: meetingId})
          .then((response) => {
            this.fetchUserCourses()
          })
        }
      }
    }
  }
</script>

<style type="text/css">
  .course-list-iltem tbody tr{
    background: #DCDCDC;
    font-size: 12px;
    cursor: pointer;
  }
  .course-list-iltem tbody tr:hover {
    background: #C0C0C0;
  }
  .course-list-iltem tbody tr {
    margin-bottom: 5px;
    display: table;
    width: 100%;
    vertical-align: middle;
  }
  .course-list-iltem thead {
    display: table-caption;
    width: 100%;
  }
  .course-list-iltem tbody tr .check_box {
    display: inline-block;
    margin-top: 14px;
    position: absolute;
    right: 0px;
  }
  .course-list-iltem tbody { 
    border-top: 2px solid #C0C0C0;
  }
  .table td {
    vertical-align: middle !important;
  }
  .user-schedule{
    color: gray;
  }
  .course_description p {
    padding-top: 13px !important;
  }
  .table-responsive table td{
    padding: 0px 10px;
  }
</style>
