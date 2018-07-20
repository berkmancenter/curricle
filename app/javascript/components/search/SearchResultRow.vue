<template>
  <div
    :class="{ row: true, 'curricle-search-result': true, selected, conflicted: isConflicted, hiddenConflict }"
    :style="borderStyle">
    <div class="col-md-1">
      <course-action
        :course="course.id"
        type="tray"/>
      <br>
      <course-action
        :course="course.id"
        type="schedule"/>
      <br>
      <course-action
        :course="course.id"
        type="annotated"/>
      <br>
      <course-action
        :course="course.id"
        type="tagged"/>
    </div>

    <div
      class="col-md-2 pointer"
      @click="selectCourse(course)">
      <strong>
        {{ course.academic_group }}
        <br>
        {{ course.subject }} {{ course.catalog_number }}
        <br>
        {{ course.semester }}
        <br>
        {{ course.units_maximum }} Units
        <br>
        Section {{ course.class_section }}
      </strong>
    </div>

    <div
      class="col-md-2 pointer"
      @click="selectCourse(course)">
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
      class="col-md-5 pointer"
      @click="selectCourse(course)">
      <h5>{{ course.title }}</h5>
      <truncate
        v-if="course.course_description_long"
        :length="250"
        :text="course.course_description_long"
        class="course_description"
        clamp="..."
        less="Show Less"
        type="html"/>
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
    border-left-width: 10px;
    border-left-style: solid;
    border-top: 1px solid #ccc;
    margin-left: 0;
    margin-right: 25px;
    padding-top: 10px;

    &.selected {
      background-color: #f5f7de;
    }
    &.selected:hover {
      background-color: #b0b29e;
    }

    &.conflicted {
      background-color: #ffc0cb;
      &.selected, &:hover {
        background-color: #ff91a4;
      }
    }

    h5 {
      font-size: 16px;
    }

    &:hover {
      background-color: #f0f0f0;
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
