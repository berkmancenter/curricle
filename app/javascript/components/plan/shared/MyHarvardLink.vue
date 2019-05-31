<template>
  <b-button
    :href="myHarvardLink"
    size="sm"
    target="_blank"
    variant="dark"
  >
    Send to my.harvard
  </b-button>
</template>

<script>
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
  "SearchText":"(${this.courseIdSearchString}) (STRM:${this.termCode})"
}
      `
    },
    termCode () {
      return this.courses[0].termCode
    }
  }
}
</script>
