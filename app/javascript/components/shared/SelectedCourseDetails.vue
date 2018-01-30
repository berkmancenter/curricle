<template >
  <div class="course-details">
    <div class="header mx-0">
      <p class="pull-left mb-0">
        <strong>{{ course.academic_group }}</strong><br>
        <strong>{{ `${course.subject} ${course.catalog_number}` }}</strong><br>
        <strong>{{ `${course.term_name} ${course.term_year}` }}</strong>
      </p>
      <p class="pull-right text-right mb-0">
        Component: <strong>{{ course.component || '&mdash;' }}</strong><br>
        Grading basis: <strong>{{ course.grading_basis_description || '&mdash;' }}</strong><br>
        Instructor: <strong>{{ firstInstructor || '&mdash;' }}</strong>
      </p>
    </div>

    <h3 class="course-title">{{ course.title }}</h3>

    <div class="description">
      <p class="heading">Description</p>
      <p v-html="course.course_description_long"/>
    </div>

    <div class="instructors">
      <p class="heading">Instructors</p>
      <div
        class="instructor mb-0"
        v-for="instructor in course.course_instructors"
        :key="instructor.id">
        <p class="pull-left mb-0">
          <strong>{{ instructor.display_name }}</strong>
        </p>
        <p class="pull-right text-right mb-0">
          More courses
        </p>
      </div>
    </div>

    <div class="readings">
      <p class="heading">Readings</p>
    </div>
  </div>
</template>

<script>
import truncate from 'vue-truncate-collapsed'

export default {
  components: {
    truncate
  },
  props: {
    course: {
      type: Object,
      required: true
    }
  },
  computed: {
    firstInstructor () {
      if (this.course.course_instructors.length) {
        return this.course.course_instructors[0].display_name
      }
    }
  }
}
</script>

<style lang="scss" scoped>
  .course-details {
    display: inline-block;
    font-size: 12px;
    width: 100%;

    .header {
      display: inline-block;
      line-height: 16px;
      margin-bottom: 20px;
      width: 100%;

      p.pull-left {
        clear: left;
        width: 40%;
      }

      p.pull-right {
        clear: right;
        width: 60%;
      }
    }

    h3.course-title {
      color: #00f;
      font-size: 18px;
      margin-bottom: 20px;
    }

    p.heading {
      border-bottom: 1px solid #999;
      margin-bottom: 8px;
    }

    .instructors {
      display: inline-block;
      margin-bottom: 20px;
      width: 100%;

      .instructor {
        border-bottom: 1px solid #999;
        cursor: not-allowed;
        display: inline-block;
        padding: 4px 0;
        width: 100%;
      }
    }
  }
</style>
