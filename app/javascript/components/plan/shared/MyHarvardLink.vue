<template>
  <div>
    <b-button
      id="myHarvardLink"
      :href="myHarvardLink"
      size="sm"
      target="_blank"
      variant="dark"
    >
      Export to my.Harvard
    </b-button>

    <b-popover
      target="myHarvardLink"
      placement="bottom"
      triggers="hover"
    >
      <template slot="default">
        Sends all courses in<br>
        your schedule that are<br>
        offered this semester<br>
        to my.Harvard
      </template>
    </b-popover>
  </div>
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
