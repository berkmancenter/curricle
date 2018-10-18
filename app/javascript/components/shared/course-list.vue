<template>
  <div class="table-responsive">
    <table class="course-list-item invert table table-borderless">
      <thead />
      <tbody>
        <tr
          v-for="course in courses"
          :key="course.id"
          :class="{ selected: currentCourse && currentCourse.id == course.id }"
          @mouseenter="addProvisionalCourse(course)"
          @mouseleave="removeProvisionalCourse(course)"
        >
          <td>{{ `${course.subject} ${course.catalog_number}` }}</td>
          <td @click="selectCourse(course)">{{ course.title }}</td>
          <td>
            <course-action
              v-show="editable"
              :course="course.id"
              :invert="invert"
              type="annotated"
            />

            <course-action
              v-show="editable"
              :course="course.id"
              :invert="invert"
              type="schedule"
            />
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'
import CourseAction from 'components/shared/CourseAction'

export default {
  components: {
    CourseAction
  },
  props: {
    courses: {
      type: Array,
      required: true
    },
    editable: {
      type: Boolean,
      default: true
    },
    invert: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    ...mapGetters('app', ['currentCourse'])
  },
  methods: {
    ...mapActions('app', ['selectCourse']),
    ...mapActions('plan', ['addProvisionalCourse', 'removeProvisionalCourse'])
  }
}
</script>

<style lang="scss">
.course-list-item {
  tbody {
    tr {
      margin-bottom: 5px;
      width: 100%;
      vertical-align: middle;
      font-size: 12px;
      cursor: pointer;
      height: 60px;
    }
  }

  thead {
    display: table-caption;
    width: 100%;
  }

  td {
    vertical-align: middle !important;
  }
}

</style>
