<template>
  <div
    class="row curricle-search-result"
    :style="borderStyle">
    <div class="col-md-1">
      <course-action
        type="tray"
        :course="course.id"
      />
      <br>
      <course-action
        type="schedule"
        :course="course.id"
      />
      <br>
      <course-action
        type="annotated"
        :course="course.id"
      />
      <br>
      <course-action
        type="tagged"
        :course="course.id"
      />
      <br>
      <course-action
        type="shareable"
        :course="course.id"
      />
    </div>
    <div class="col-md-2">
      <strong>
        {{ course.academic_group }}
        <br>
        {{ course.subject }} {{ course.catalog_number }}
        <br>
        {{ course.semester }}
        <br>
        {{ course.units_maximum }} Units
      </strong>
    </div>
    <div class="col-md-2">
      Component: <strong>{{ course.component }}</strong>
      <br>
      Grading Basis:
      <br>
      Instructor:
      <span
        v-for="instructor in course.course_instructors"
        :key="instructor.id">
        <strong>
          {{ instructor.display_name }}
        </strong>
      </span>
    </div>
    <div class="col-md-6">
      <h5>{{ course.title }}</h5>
      <span v-html="course.course_description_long"/>
    </div>
    <div class="col-md-2">
      Schedule
    </div>
  </div>
</template>

<script>
import CourseAction from 'components/shared/course-action'

export default {
  components: {
    CourseAction
  },
  props: {
    course: {
      type: Object,
      required: true
    }
  },
  computed: {
    borderStyle () {
      // TODO: map course color to data
      const randomColor = Math.floor((Math.random() * (999 - 599)) + 600)

      return {
        'border-left-color': ('#' + randomColor)
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.curricle-search-result {
  font-size: 13px;
  border-left-width: 10px;
  border-left-style: solid;
  border-top: 1px solid #ccc;
  margin-left: 0;
  padding-top: 10px;

  h5 {
    font-size: 16px;
  }
}
.usercourse, .userschedule {
  color: gray;
}
</style>
