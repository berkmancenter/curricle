<template>
  <div id="interfaceContainer">
    <div id="searchContainer">
      <div id="search">
        <b-form @submit="callRequestData">
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

export default {
  data () {
    return {
      instructorName: ''
    }
  },
  mounted () {
    initSetup()
  },
  methods: {
    callRequestData () {
      requestData(this.instructorName)
    }
  }
}
</script>

<style lang="scss" scoped>
  div /deep/ svg {
    display: block;
    margin: auto;

    .contributionCircle {
      fill: none;
      stroke: #000;
      stroke-width: 0.5px;
      stroke-opacity: 0.5;
    }

    .instructorLine, .pageLine {
      stroke-width: 1px;
      stroke-opacity: 1;
    }

    .departmentText {
      fill: #00ADF0;
      text-anchor: end;
    }

    .classText, .classCircle, .classLine, .selectedInstructorText, .departmentText, .instructorText {
      cursor: pointer;
    }

    .classText {
      fill: #2C3194;
    }

    .classText:hover {
      fill: red;
    }

    .instructorText {
      fill: #D10F84;
    }

    .selectedInstructorText:hover {
      fill: red;
    }

    .departmentText:hover {
      fill: red;
    }

    .instructorText:hover {
      fill: red;
    }
  }
</style>
