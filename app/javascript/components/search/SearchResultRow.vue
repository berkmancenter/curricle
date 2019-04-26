<template>
  <div
    :class="{ selected, conflicted: isConflicted, hiddenConflict }"
    :style="borderStyle"
    class="row curricle-search-result mb-5 mx-1 py-2"
  >
    <div class="col-md-1 pt-1">
      <course-action
        :course="course.id"
        :invert="selected"
        class="mr-5"
        type="tray"
      />

      <span class="text-muted">
        &mdash;
      </span>

      <br>

      <course-action
        :course="course.id"
        :invert="selected"
        class="mr-1"
        type="tagged"
      />

      <course-action
        :course="course.id"
        :invert="selected"
        type="annotated"
      />
    </div>

    <div
      class="col-md-9 pointer pl-0"
      @click="selectCourse(course)"
    >
      <div
        class="course-title font-weight-bold text-uppercase"
        :class="courseIdStyles(course.id)"
      >
        {{ course.subject }} {{ course.catalogNumber }}: {{ course.title }}
      </div>

      <hr
        :class="selected"
        class="m-0"
      >

      <span class="course-instructor">
        {{ instructorNames }}
      </span>

      <div
        class="course-component text-uppercase"
      >
        {{ course.component }}<br>
        {{ course.termName }} {{ course.termYear }}
      </div>
    </div>

    <div class="col-md-2 px-0">
      <class-meeting-time
        :condensed="true"
        :conflicts="conflicts"
        :course="course"
      />
    </div>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'
import CourseAction from 'components/shared/CourseAction'
import ClassMeetingTime from 'components/shared/ClassMeetingTime'

export default {
  components: {
    CourseAction,
    ClassMeetingTime
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
    ...mapGetters('user', ['courseIdStyles']),
    borderStyle () {
      return {
        'border-left-color': this.course.department_color || '#000'
      }
    },
    hiddenConflict () {
      return this.isConflicted && !this.showConflicts
    },
    instructorNames () {
      const limit = 4 // only display this many instructors inline

      let formattedString = this
        .course
        .courseInstructors
        .slice(0, limit)
        .map(instructor => instructor.displayName)
        .join(', ')

      if (this.course.courseInstructors.length > limit) {
        formattedString += '...'
      }

      return formattedString
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

      &.selected,
      &:hover {
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

  .hiddenConflict {
    height: 0;
    display: none;
    transition: height 2s;
  }

  .usercourse,
  .userschedule {
    color: gray;
  }
</style>
