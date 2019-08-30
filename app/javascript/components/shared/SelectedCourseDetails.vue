<template>
  <div>
    <div class="mb-3 row">
      <div class="col-lg-7">
        <p class="font-weight-bold text-uppercase">
          {{ course.title }}
        </p>
      </div>

      <div class="col-lg-3 text-uppercase">
        {{ `${course.subject} ${course.catalogNumber}` }}<br>
        {{ course.component || '&mdash;' }}<br>
        {{ `${course.academicGroup} &mdash; ${course.termName} ${course.termYear}` }}
      </div>

      <div class="col-lg-2 text-uppercase">
        <span v-if="qGuideUrl">
          <a
            target="_blank"
            :href="qGuideUrl"
            @click="$matomo.trackEvent('Q Guide', 'Click', course.id)"
          >
            Q Guide
          </a>

          <br>
        </span>

        <a
          target="_blank"
          :href="syllabusUrl"
          @click="$matomo.trackEvent('Syllabus', 'Click', course.id)"
        >
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

        <annotations
          v-if="userAuthenticated"
          :course="course"
        />
      </div>
    </div>
  </div>
</template>

<script>
import Annotations from './SelectedCourseDetailsAnnotations'
import truncate from 'vue-truncate-collapsed'

export default {
  components: {
    Annotations,
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
    qGuideUrl () {
      if (!this.course.qGuideCourseId) { return }

      return `https://course-evaluation-reports.fas.harvard.edu/fas/course_summary.html?course_id=${this.course.qGuideCourseId}`
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
