<template>
  <div>
    <div class="mb-3 row">
      <div class="col-lg-5">
        <p class="font-weight-bold text-uppercase">
          {{ course.title }}
        </p>
      </div>

      <div class="col-lg-2 text-uppercase">
        {{ course.academicGroup }}<br>
        {{ `${course.subject} ${course.catalogNumber}` }}<br>
        {{ `${course.termName} ${course.termYear}` }}
      </div>

      <div class="col-lg-3 text-uppercase">
        {{ course.component || '&mdash;' }}<br>
        {{ course.gradingBasisDescription || '&mdash;' }}<br>
        {{ firstInstructor || '&mdash;' }}
      </div>

      <div class="col-lg-2 text-uppercase">
        <a :href="syllabusUrl">
          Syllabus
        </a>
      </div>
    </div>

    <div class="row">
      <div class="col-lg-7 mb-4">
        <p class="heading">
          Description
        </p>

        <truncate
          v-if="course.courseDescriptionLong"
          :length="500"
          :text="course.courseDescriptionLong"
          clamp="[...]"
          less="[Close]"
          type="html"
        />

        <p class="heading mt-4">
          Course Attributes
        </p>

        <span
          v-for="attribute in course.courseAttributes"
          :key="attribute.id"
        >
          <strong>{{ attribute.crseAttributeDescription }}:</strong> {{ attribute.crseAttrValueDescription }}
          <br>
        </span>
      </div>

      <div class="col-lg-5">
        <p class="heading">
          Instructors
        </p>

        <div
          v-for="instructor in course.courseInstructors"
          :key="instructor.id"
        >
          <p class="mb-0">
            {{ instructor.displayName }}
          </p>
        </div>

        <selected-course-annotations
          v-if="userAuthenticated"
          :course-id="course.id"
        />

        <selected-course-tagging
          v-if="userAuthenticated"
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
      if (!this.course.courseInstructors.length) { return }

      return this.course.courseInstructors[0].displayName
    },
    syllabusUrl () {
      return `https://syllabus.harvard.edu/?course_id=${this.course.externalCourseId}`
    }
  }
}
</script>

<style lang="scss" scoped>
p.heading {
  border-bottom: 1px solid #999;
  margin-bottom: 8px;
}

a {
  color: black;
}
</style>
