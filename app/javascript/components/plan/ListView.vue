<template>
  <div>
    <department-selector />

    <semester-selector
      mode="filter"
      source="tray"
    />

    <br>

    <my-harvard-link
      v-if="semester && scheduleCourses.length"
      :courses="scheduleCourses"
      class="mt-2 mb-4"
    />

    <div
      v-for="course in filteredCourses"
      :key="course.id"
      :class="{ selected: selected(course) }"
      class="row plan-list-item mb-3 mx-1 py-2"
      @click="selectCourse(course)"
    >
      <div class="col-md-1 pt-1 pointer">
        <course-action
          :course="course.id"
          :invert="selected(course)"
          class="mr-1"
          type="tray"
        />

        <br>

        <course-action
          :course="course.id"
          :invert="selected(course)"
          class="mr-3"
          type="schedule"
        />
      </div>

      <div class="col-md-2 pointer">
        <div class="text-uppercase font-weight-bold course-title">
          {{ course.title }}
        </div>

        <span
          v-for="instructor in course.courseInstructors"
          :key="instructor.id"
          class="course-instructor"
        >
          {{ instructor.displayName }}
        </span>
      </div>

      <div class="col-md-2 pointer text-uppercase">
        {{ course.subject }} {{ course.catalogNumber }}<br>
        {{ course.termName }} {{ course.termYear }}<br>
        {{ course.component }}
      </div>

      <div class="col-md-5 pointer">
        <truncate
          v-if="course.courseDescriptionLong"
          :length="200"
          :text="course.courseDescriptionLong"
          class="course_description"
          clamp="[..]"
          less="Show Less"
          type="html"
        />
      </div>

      <div class="col-md-2 px-0">
        <class-meeting-time
          :course="course"
          :condensed="true"
        />
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapGetters, mapState } from 'vuex'
import truncate from 'vue-truncate-collapsed'
import CourseAction from 'components/shared/CourseAction'
import ClassMeetingTime from 'components/shared/ClassMeetingTime'
import DepartmentSelector from 'components/plan/DepartmentSelector'
import MyHarvardLink from 'components/plan/MyHarvardLink'
import SemesterSelector from 'components/plan/SemesterSelector'

export default {
  components: {
    truncate,
    CourseAction,
    ClassMeetingTime,
    DepartmentSelector,
    MyHarvardLink,
    SemesterSelector
  },
  computed: {
    ...mapGetters('app', ['currentCourse']),
    ...mapGetters('plan', ['filteredCourses', 'scheduledCoursesBySemester']),
    ...mapState('plan', ['filters']),
    scheduleCourses () {
      return this.scheduledCoursesBySemester[this.semester] || []
    },
    semester () {
      return this.filters.semester
    }
  },
  methods: {
    ...mapActions('app', ['selectCourse']),
    selected (course) {
      return this.currentCourse && this.currentCourse.id === course.id
    }
  }
}
</script>

<style lang="scss" scoped>
  .plan-list-item {
    font-size: 13px;
    border-radius: 4px;

    &.selected {
      background-color: black;
      color: white;

      &:hover {
        background-color: #222;
      }
    }

    .course-title {
      font-size: 16px;
      line-height: 20px;
    }
  }
</style>