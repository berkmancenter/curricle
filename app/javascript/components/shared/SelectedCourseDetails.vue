<template>
  <div>
    <div class="mb-3 row">
      <div class="col-lg-5">
        <h2 class="font-weight-bold text-uppercase">
          {{ course.title }}
        </h2>
      </div>

      <div class="col-lg-2 text-uppercase">
        {{ course.academic_group }}<br>
        {{ `${course.subject} ${course.catalog_number}` }}<br>
        {{ `${course.term_name} ${course.term_year}` }}
      </div>

      <div class="col-lg-5 text-uppercase">
        {{ course.component || '&mdash;' }}<br>
        {{ course.grading_basis_description || '&mdash;' }}<br>
        {{ firstInstructor || '&mdash;' }}
      </div>
    </div>

    <div class="row">
      <div class="col-lg-7 mb-4">
        <p class="heading">
          Description
        </p>

        <truncate
          v-if="course.course_description_long"
          :length="500"
          :text="course.course_description_long"
          clamp="[...]"
          less="[Close]"
          type="html"
        />
      </div>

      <div class="col-lg-5">
        <p class="heading">
          Instructors
        </p>

        <div
          v-for="instructor in course.course_instructors"
          :key="instructor.id"
        >
          <p class="mb-0">
            {{ instructor.display_name }}
          </p>
        </div>

        <selected-course-annotations
          v-if="userAuthenticated"
          :course-id="course.id"
        />

        <selected-course-tagging
          :course-id="course.id"
        />
      </div>
    </div>
  </div>
</template>

<script>
import SelectedCourseAnnotations from './SelectedCourseAnnotations'
import SelectedCourseTagging from './SelectedCourseTagging'
import truncate from 'vue-truncate-collapsed'

export default {
  components: {
    SelectedCourseAnnotations,
    SelectedCourseTagging,
    truncate
  },
  props: {
    course: {
      type: Object,
      required: true
    },
    userAuthenticated: {
      type: Boolean,
      required: true
    }
  },
  computed: {
    firstInstructor () {
      if (!this.course.course_instructors.length) { return }

      return this.course.course_instructors[0].display_name
    }
  }
}
</script>

<style lang="scss" scoped>
p.heading {
  border-bottom: 1px solid #999;
  margin-bottom: 8px;
}
</style>
