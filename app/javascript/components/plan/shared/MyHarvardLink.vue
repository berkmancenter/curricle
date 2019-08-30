<template>
  <b-button
    id="myHarvardLink"
    v-b-modal.export-modal
    size="sm"
    variant="dark"
    @click="$matomo.trackEvent('Export', 'Click')"
  >
    Export to my.harvard

    <b-modal
      id="export-modal"
      size="lg"
    >
      <template slot="default">
        <p class="px-3">
          Before you leave Curricle to continue enrolling in my.harvard...
        </p>

        <p class="px-3">
          We ask you to take <strong>three minutes</strong> of your time and
          <strong>fill out a short survey</strong> on your experience with using
          Curricle. Your feedback is invaluable to our continued efforts to
          improve the tool for the semesters to come.
        </p>

        <p class="px-3">
          Thanks!
        </p>

        <div class="row px-3 mb-3">
          <div class="col pr-1">
            <b-button
              id="button-no"
              class="text-center"
              :href="myHarvardLink"
              target="_blank"
              variant="light"
            >
              NO, take me to my.harvard
            </b-button>
          </div>

          <div class="col pl-1">
            <b-button
              id="button-yes"
              href="https://forms.gle/pJGzsArGDAGaqN2R8"
              target="_blank"
              variant="dark"
            >
              YES, I'd like to
              <br>
              share my feedback!
            </b-button>
          </div>
        </div>
      </template>
    </b-modal>

    <b-popover
      target="myHarvardLink"
      placement="bottom"
      triggers="hover"
    >
      Sends all courses in<br>
      your schedule that are<br>
      offered this semester<br>
      to my.harvard
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

<style lang="scss" scoped>
#button-no, #button-yes {
  align-items: center;
  display: flex;
  height: 62px;
  justify-content: center;
  width: 100%;
}

#button-no {
  border: 1px solid black;

  &:hover {
    background-color: #dcdcdc;
  }
}
</style>
