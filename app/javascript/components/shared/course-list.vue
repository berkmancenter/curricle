<template>
  <div class="table-responsive">
    <table class="course-list-iltem table">
      <thead/>
      <tbody>
        <tr
          v-for="course in courses"
          :key="course.id"
          @click="selectCourse(course)"
        >
          <td>{{ course.external_course_id }}</td>
          <td>{{ course.title }}</td>
          <td :style="calcStyle(course)">
            <course-action
              type="schedule"
              :course="course.id"
            />
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import CourseAction from 'components/shared/course-action'

export default {
  components: {
    CourseAction
  },
  props: {
    courses: {
      type: Array,
      required: true
    }
  },
  methods: {
    ...mapActions('user', ['selectCourse']),
    calcStyle (course) {
      return 'border-right: 5px solid ' + (course.department_color || '#000')
    }
  }
}
</script>

<style>
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

</style>
