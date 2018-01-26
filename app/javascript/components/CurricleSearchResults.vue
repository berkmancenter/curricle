<template>
  <div
    class="row curricle-search-result"
    :style="borderStyle">
    <div class="col-md-1">
      <course-action
        type="tray"
        :course="id"
      />
      <br>
      <course-action
        type="schedule"
        :course="id"
      />
      <br>
      <course-action
        type="annotated"
        :course="id"
      />
      <br>
      <course-action
        type="tagged"
        :course="id"
      />
      <br>
      <course-action
        type="shareable"
        :course="id"
      />
    </div>
    <div class="col-md-2">
      <strong>
        {{ academic_group }}
        <br>
        {{ subject }} {{ catalog_number }}
        <br>
        {{ term_name }} {{ term_year }}
        <br>
        {{ units_maximum }} Units
      </strong>
    </div>
    <div class="col-md-2">
      Component: <strong>{{ component }}</strong>
      <br>
      Grading Basis:
      <br>
      Instructor:
      <span
        v-for="instructor in course_instructors"
        :key="instructor.id">
        <strong>
          {{ instructor.display_name }}
        </strong>
      </span>
    </div>
    <div class="col-md-6">
      <h5>{{ title }}</h5>
      <span v-html="description"/>
    </div>
    <div class="col-md-2">
      Schedule
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import CourseAction from 'components/shared/course-action'

export default {
  components: {
    CourseAction
  },
  props: {
    academic_group: {
      type: String,
      required: true
    },
    catalog_number: {
      type: Number,
      required: true
    },
    component: {
      default: '',
      type: String
    },
    course_instructors: {
      type: Array,
      default () {
        return []
      }
    },
    description: {
      type: String,
      default: ''
    },
    id: {
      type: String,
      required: true
    },
    subject: {
      type: String,
      required: true
    },
    term_name: {
      type: String,
      required: true
    },
    term_year: {
      type: Number,
      required: true
    },
    title: {
      type: String,
      required: true
    },
    units_maximum: {
      type: Number,
      required: true
    },
    meeting: {
      type: Object,
      default () {}
    }
  },
  computed: {
    borderStyle () {
      // TODO: map course color to data
      const randomColor = Math.floor((Math.random() * (999 - 599)) + 600)

      return {
        'border-left-color': ('#' + randomColor)
      }
    },
    ...mapGetters('user', {
      userCoursesScheduleIds: 'userCoursesScheduleIds',
      userCourseIds: 'userCourseIds'
    })
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
