<template>
  <div class="calendar-sidebar">
    <div
      v-for="(courses, day) in calendarEvents"
      :key="day">
      <strong>{{ day }}</strong>
      <div class="table-responsive">
        <table class="course-list-iltem table">
          <thead/>
          <tbody>
            <tr
              v-for="course in courses"
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
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
import CourseAction from 'components/shared/course-action'

export default {
  components: {
    CourseAction
  },
  computed: {
    ...mapState('app', ['viewmode']),
    ...mapGetters('user', ['coursesByDate', 'coursesByYear']),
    calendarEvents () { return this.viewmode.tray === 'multi-year' ? this.coursesByYear : this.coursesByDate }
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
