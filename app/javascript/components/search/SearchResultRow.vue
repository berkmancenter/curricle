<template>
  <div
    :class="{ selected, conflicted: isConflicted, hiddenConflict }"
    :style="borderStyle"
    class="row curricle-search-result mb-5 mx-1 py-2">
    <div class="col-md-1 pt-1">
      <course-action
        :course="course.id"
        :invert="selected"
        class="mr-1"
        type="tray"/>

      <course-action
        :course="course.id"
        :invert="selected"
        class="mr-3"
        type="schedule"/>

      <span class="text-muted">&mdash;</span>

      <br>

      <course-action
        :course="course.id"
        :invert="selected"
        class="mr-1"
        type="tagged"/>

      <course-action
        :course="course.id"
        :invert="selected"
        type="annotated"/>

    </div>

    <div
      class="col-md-9 pointer pl-0"
      @click="selectCourse(course)">
      <div
        class="course-title font-weight-bold text-uppercase">
        {{ course.subject }} {{ course.catalog_number }}: {{ course.title }}
      </div>

      <hr
        :class="selected"
        class="m-0">

      <span
        v-for="instructor in course.course_instructors"
        :key="instructor.id"
        class="course-instructor">
        {{ instructor.display_name }}
      </span>

      <div
        class="course-component text-uppercase">
        {{ course.component }}
      </div>
    </div>

    <div class="col-md-2 px-0">
      <class-meeting-time
        :schedule="course.schedule"
        :conflicts="conflicts"/>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import CourseAction from 'components/shared/CourseAction'
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
    },
    selected: {
      type: Boolean,
      default: false
    },
    conflicts: {
      type: Array,
      default () {
        return []
      }
    },
    isConflicted: {
      type: Boolean,
      default: false
    },
    showConflicts: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    borderStyle () {
      return {
        'border-left-color': this.course.department_color || '#000'
      }
    },
    hiddenConflict () {
      return this.isConflicted && !this.showConflicts
    }
  },
  methods: {
    ...mapActions('app', ['selectCourse'])
  }
}
</script>

<style lang="scss" scoped>
  .curricle-search-result {
    font-size: 13px;
    border-radius: 4px;

    &.selected {
      background-color: black;
      color: white;

      &:hover {
        background-color: #222;
      }
    }

    &.conflicted {
      background-color: #ffc0cb;

      &.selected, &:hover {
        background-color: #ff91a4;
      }
    }

    .course-title {
      font-size: 20px;
    }

    .course-instructor {
      font-size: 16px;
    }

    .course-component {
      font-size: 14px;
    }

    &:hover {
      background-color: #f0f0f0;
    }

    hr {
      border-color: #e0e0e0;
    }
  }

  .pointer {
    cursor: pointer;
  }

  .hiddenConflict {
    height: 0px;
    display: none;
    transition: height 2s;
  }

  .usercourse, .userschedule {
    color: gray;
  }
</style>
