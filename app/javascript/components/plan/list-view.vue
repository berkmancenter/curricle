<template>
  <div class="plan">
    <table class="course-list-iltem table">
      <tbody>
        <tr
          v-for="course in filteredCourses"
          :key="course.id"
          :class="{ selected: currentCourse && currentCourse.id == course.id }"
          @click="selectCourse(course)">
          <td>{{ course.external_course_id }}</td>
          <td style = "width: 12em;">{{ course.course_description }}</td>
          <td>{{ course.academic_group }} <br> {{ course.subject }} {{ course.catalog_number }}</td>
          <td>{{ course.term_name }} <br> {{ course.units_maximum }} units</td>
          <td style = "width: 16em; text-align: justify;">
            <truncate
              v-if="course.course_description_long"
              :length="50"
              :text="course.course_description_long"
              class="course_description"
              clamp="..."
              less="Show Less"
              type="html"/>
          </td>
          <td>
            <class-meeting-time
              :schedule="course.schedule"
              :condensed="true"
            />
          </td>
          <td :style="'border-right: 5px solid ' + course.department_color + '; position: relative; font-size: 24px;'">
            <course-action
              :course="course.id"
              type="schedule"/>
            <course-action
              :course="course.id"
              type="annotated"/>
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
import CourseAction from 'components/shared/CourseAction'
import ClassMeetingTime from 'components/shared/ClassMeetingTime'

export default {
  components: {
    truncate,
    CourseAction,
    ClassMeetingTime
  },
  computed: {
    ...mapGetters('app', ['currentCourse']),
    ...mapGetters('plan', ['filteredCourses'])
  },
  methods: {
    ...mapActions('app', ['selectCourse'])
  }
}
</script>

<style type="text/css">
  #app header .navbar-light .navbar-nav a {
    color: #000;
  }
  .your-tray {
    color: #000;
    font-weight: bold;
    margin-bottom: 0px;
  }
  .dropdown button, .dropdown button:hover, .dropdown button:focus {
    background-color: inherit;
    color: #000;
    border: none;
  }
  .btn-secondary:not([disabled]):not(.disabled):active, .btn-secondary:not([disabled]):not(.disabled).active, .show > .btn-secondary.dropdown-toggle {
    background-color: inherit !important;
    color: #000 !important;
    border: none !important;
    box-shadow: inherit !important;
  }
  hr {
    border-color: #000 !important;
    border-width: 2px !important;
    margin-top: 0px !important;
  }

  .course-list-iltem tbody tr{
    background: #DCDCDC;
    font-size: 12px;
    cursor: pointer;
  }
  .course-list-iltem tbody tr.selected {
    background-color: #f5f7de;
  }
  .course-list-iltem tbody tr.selected:hover {
    background-color: #b0b29e;
  }

  .course-list-iltem tbody tr:hover {
    background: #C0C0C0;
  }
  .course-list-iltem tbody tr {
    margin-bottom: 5px;
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
  .plan table td{
    padding: 0px 10px;
  }

</style>
