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
    <div
      class="col-md-2"
      @click="selectCourse(course)"
    >
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
    <div
      class="col-md-2"
      @click="selectCourse(course)"
    >
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
    <div
      class="col-md-5"
      @click="selectCourse(course)"
    >
      <h5>{{ course.title }}</h5>
      <truncate
        class="course_description"
        clamp="..."
        :length="250"
        less="Show Less"
        type="html"
        :text="course.course_description_long"
        v-if="course.course_description_long"/>
    </div>
    <div class="col-md-2">
      <class-meeting-time :days="course.days" />
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import CourseAction from 'components/shared/course-action'
import ClassMeetingTime from 'components/shared/ClassMeetingTime'
import truncate from 'vue-truncate-collapsed'

export default {
  components: {
    CourseAction,
    ClassMeetingTime,
    truncate
  },
  props: {
    course: {
      type: Object,
      required: true
    }
  },
  computed: {
    borderStyle () {
      return {
        'border-left-color': this.course.department_color || '#000'
      }
    }
  },
  methods: {
    ...mapActions('user', ['selectCourse'])
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
