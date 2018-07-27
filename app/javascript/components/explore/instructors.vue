<template>
  <div id="interfaceContainer">
    <div id="searchContainer">
      <semester-input class="mb-2"/>

      <div id="search">
        <b-form @submit="onSubmit">
          <b-form-group
            label="Instructor name:"
            label-for="instructorName">
            <b-form-input
              id="instructorName"
              v-model="instructorName"
              type="search"
              required
              placeholder="Enter name"/>
          </b-form-group>
          <b-button
            type="submit"
            variant="primary">
            Submit
          </b-button>
        </b-form>
      </div>
    </div>
    <div id="visContainer"/>
  </div>
</template>

<script>
import { initSetup, requestData } from 'lib/explore/instructors'
import { mapActions, mapGetters } from 'vuex'
import SemesterInput from 'components/search/SearchFormSemesterInput'

export default {
  components: {
    SemesterInput
  },
  data () {
    return {
      instructorName: ''
    }
  },
  computed: {
    ...mapGetters('search', ['semesterStart'])
  },
  mounted () {
    initSetup(this.selectCourse)
  },
  methods: {
    ...mapActions('app', ['selectCourse']),
    onSubmit (e) {
      e.preventDefault()
      requestData(this.instructorName, this.semesterStart)
    }
  }
}
</script>

<style lang="scss" scoped>
  #visContainer /deep/ svg {
    display: block;
    margin: auto;

    .contributionCircle {
      fill: none;
      stroke: #000;
      stroke-width: 0.5px;
      stroke-opacity: 0.5;
    }

    .instructorLine,
    .pageLine {
      stroke-width: 1px;
      stroke-opacity: 1;
    }

    .departmentText {
      fill: #00ADF0;
      text-anchor: end;

      &:hover {
        fill: red;
      }
    }

    .classText,
    .classCircle,
    .classLine,
    .selectedInstructorText,
    .departmentText,
    .instructorText {
      cursor: pointer;
    }

    .classText {
      fill: #2C3194;

      &:hover {
        fill: red;
      }
    }

    .instructorText {
      fill: #D10F84;

      :hover {
        fill: red;
      }
    }

    .selectedInstructorText:hover {
      fill: red;
    }
  }
</style>
