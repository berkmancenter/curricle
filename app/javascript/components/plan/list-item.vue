<template>
  <div class="table-responsive">
    <table class="course-list-iltem table">
      <thead/>
      <tbody>
        <tr
          v-for="list in trayCourses"
          :key="list.id"
          @click="selectCourse(list)">
          <td>{{ list.external_course_id }}</td>
          <td style = "width: 12em;">{{ list.course_description }}</td>
          <td>{{ list.academic_group }} <br> {{ list.subject }}</td>
          <td>{{ list.term_name }} <br> {{ list.units_maximum }} units</td>
          <td style = "width: 16em; text-align: justify;">
            <truncate
              class="course_description"
              clamp="..."
              :length="50"
              less="Show Less"
              type="html"
              :text="list.course_description_long"
              v-if="list.course_description_long"/>
          </td>
          <td>4 pm to 6pm<br> 9 am to 10 pm</td>
          <td>
            <span>M<img src=""></span>
            <br>
            <span>W<img src=""></span>
          </td>
          <td style="border-right: 5px solid #000; position: relative; font-size: 24px;">
            <course-action
              type="schedule"
              :course="list.id"
            />
          </td>
          <span class= "check_box">
            <input
              type="checkbox"
              name=""
              value="">
          </span>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import truncate from 'vue-truncate-collapsed'
export default {
  components: {
    'truncate': truncate
  },
  computed: {
    ...mapGetters('user', ['trayCourses'])
  },
  methods: {
    ...mapActions('user', ['selectCourse'])
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
