<template>
  <div
    class="row py-5"
  >
    <div
      class="col-md-8"
    >
      <h3>
        Tools:
      </h3>

      <p class="mb-5">
        Curricle is the nexus of a network of tools and platforms that provide you with support along the course selection journey. Here are a few to note.
      </p>

      <tools-row
        v-for="(row, index) in rows"
        :key="index"
        v-bind="row"
      />
    </div>
  </div>
</template>

<script>
import ToolsRow from './ToolsRow'

export default {
  components: {
    ToolsRow
  },
  data () {
    return {
      rows: [
        {
          buttonLabel: 'my.harvard',
          description: 'Ready to register for your classes this semester? Once your schedule has been fully worked out in Curricle and you have exported your schedule, don’t forget to go to my.harvard to complete the registration process. my.harvard is the centralized information system used by students to manage course registration, advising, and graduation planning and used by faculty, staff, and administrators to manage enrollments and advising.',
          link: 'https://portal.my.harvard.edu'
        },
        {
          buttonLabel: 'Syllabus Explorer',
          description: 'Want to browse individual course syllabi? Syllabus Explorer provides access to over 10,000 Harvard syllabi dating back to the 2015-16 academic year. A link to the relevant Syllabus Explorer record (when available) can be found in every course pop-up window in Curricle.',
          link: 'https://syllabus.harvard.edu'
        },
        {
          buttonLabel: 'Q Evaluations',
          description: 'Curious about what previous students thought of a course and its workload? Consult the Q guide for course evaluations. Keep in mind that courses vary from year to year, as do instructors, and that new courses or non-recurring courses will be absent as well, so Q Evaluations from prior years are an imperfect selection tool. A link to the relevant Q Evaluation record (when available) can be found in every course pop-up window in Curricle.',
          link: 'https://q.fas.harvard.edu'
        },
        {
          buttonLabel: 'Gen Ed Requirements',
          description: 'Confused about Gen Ed or other requirements? The Program in General Education’s Resources page explains the four categories of required courses, as well as providing links to pages that explain the College\'s language requirement, Expository Writing requirement, Divisional Distribution requirement, and Quantitative Reasoning with Data requirement.',
          link: 'https://gened.fas.harvard.edu/resources-students'
        }
      ]
    }
  }
}
</script>
