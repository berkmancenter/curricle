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
          buttonLabel: 'my.Harvard',
          description: 'Once you have your semester schedule planned out here, don’t forget to go to my.Harvard to complete your course registration.',
          link: 'https://portal.my.harvard.edu'
        },
        {
          buttonLabel: 'Syllabus Explorer',
          description: 'Read through the syllabi of courses in your plan to get a glimpse of the exciting intellectual journeys ahead.',
          link: 'https://syllabus.harvard.edu'
        },
        {
          buttonLabel: 'Q Evaluations',
          description: 'Curious about what previous students thought of a course and its workload? Check out the Q guide for past course evaluations.',
          link: 'https://q.fas.harvard.edu'
        },
        {
          buttonLabel: 'Gen Ed Requirements',
          description: 'Confused about the new Gen Ed and Distribution requirements? No sweat - this page explains them in detail.',
          link: 'https://gened.fas.harvard.edu/resources-students'
        }
      ]
    }
  }
}
</script>
