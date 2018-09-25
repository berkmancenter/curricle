<template>
  <div>
    <div
      class="text-center text-uppercase">
      Select a Component and Department

      <h4
        class="text-uppercase font-weight-bold">
        Learning Modes
      </h4>
    </div>

    <div id="visContainer">
      <div
        id="courseTypeVis"
        class="text-left">
        &nbsp; Components
      </div>

      <div
        id="departmentVis"
        class="text-right">
        Departments &nbsp;
      </div>

      <div
        id="classVis"
        class="w-100 float-left"/>
    </div>

    <div id="vis-description">
      <h3>Explore:</h3>

      <p>
        Explore courses by selecting <span class="components">components</span>
        (class formats) and <span class="departments">departments</span>
        (subjects and courses of study).

        <span
          v-b-tooltip.hover
          title="This visualization will help you explore the types of classes that are available in each department, from lecture to core studio to field experience. In the data, class types are called &quot;components.&quot; In the left column, find your desired component, and look in the right column to select your desired department. Once you have selected both a department and component, all courses fitting that criteria will appear as a list. From this list, you can select the course titles to explore more information about the courses. Click on the Department and Component to reset the visualization and start again."
          class="pointer">
          MORE&nbsp;&gt;
        </span>
      </p>

      <semester-input/>
    </div>
  </div>
</template>

<script>
import 'd3'
import 'jquery'
import { initSetup } from 'lib/explore/classes'
import { mapActions, mapGetters } from 'vuex'
import SemesterInput from 'components/search/SearchFormSemesterInput'

export default {
  components: {
    SemesterInput
  },
  computed: {
    ...mapGetters('search', ['semesterStart'])
  },
  watch: {
    semesterStart (newSemester) {
      initSetup(this.selectCourse, newSemester)
    }
  },
  mounted () {
    initSetup(this.selectCourse, this.semesterStart)
  },
  methods: {
    ...mapActions('app', ['selectCourse'])
  }
}
</script>

<style lang="scss" scoped>
#visContainer {
  width: 960px;

  /deep/ {
    svg {
      display: block;
      margin: 0;
    }

    #courseTypeVis,
    #departmentVis {
      width: 50%;
      float: left;
      overflow: scroll;
      max-height:100%;
    }

    #classVis {
      overflow: scroll;
      max-height: 100%;
    }

    .departmentText:hover {
      text-decoration: underline;
    }

    .courseTypeText:hover {
      text-decoration: underline;
    }

    .departmentText,
    .departmentRect,
    .courseTypeText,
    .courseTypeRect {
      cursor: pointer;
      fill: #2C3194;
    }

    .classText {
      cursor: pointer;

      &:hover {
        text-decoration: underline;
      }
    }
  }
}

#vis-description {
  position: fixed;
  bottom: 25px;
  margin-left: 10px;
  width: 200px;

  h3 {
    font-size: 18px;
  }

  p {
    font-size: 14px;

    span.components {
      color: #d10f84;
    }

    span.departments {
      color: #00adf0;
    }
  }
}
</style>
