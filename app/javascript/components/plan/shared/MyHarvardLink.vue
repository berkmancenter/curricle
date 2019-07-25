<template>
  <b-button
    id="myHarvardLink"
    :href="myHarvardLink"
    size="sm"
    target="_blank"
    variant="dark"
  >
    Export to my.Harvard

    <b-popover
      target="myHarvardLink"
      placement="bottom"
      triggers="hover"
    >
      Sends all courses in<br>
      your schedule that are<br>
      offered this semester<br>
      to my.Harvard
    </b-popover>
  </b-button>
</template>

<script>
import _ from 'lodash'

export default {
  props: {
    courses: {
      type: Array,
      required: true
    }
  },
  computed: {
    courseIdSearchString () {
      return this.courses
        .map(course => course.subject + course.catalogNumber)
        .join(' | ')
    },
    myHarvardLink () {
      return `
https://courses.my.harvard.edu/psp/courses/EMPLOYEE/EMPL/h/
?tab=HU_CLASS_SEARCH
&SearchReqJSON={
  "Category":"HU_SCL_SCHEDULED_BRACKETED_COURSES",
  "FacetsInResults":true,
  "SearchText":"(${this.courseIdSearchString}) (${this.termCodes})"
}
      `
    },
    termCodes () {
      return _(this.courses).map((course) => `STRM:${course.termCode}`).uniq().join(' | ')
    }
  }
}
</script>
