<template>
  <div class="mt-4">
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
          v-for="instructor in course.course_instructors"
          :key="instructor.id"
          class="course-instructor"
        >
          {{ instructor.display_name }}
        </span>
      </div>

      <div class="col-md-2 pointer text-uppercase">
        {{ course.subject }} {{ course.catalog_number }}<br>
        {{ course.term_name }} {{ course.term_year }}<br>
        {{ course.component }}
      </div>

      <div class="col-md-5 pointer">
        <truncate
          v-if="course.course_description_long"
          :length="200"
          :text="course.course_description_long"
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
