<template>
  <div>
    <div
      class="text-center text-uppercase">
      Course Universe

      <h4
        class="text-uppercase font-weight-bold">
        All Departments
      </h4>
    </div>

    <div id="visWrapper">
      <canvas id="visCANVAS"/>

      <svg id="visSVG">
        <g/>
      </svg>
    </div>

    <div id="vis-description">
      <h3>Explore:</h3>

      <p>
        Get an overview of the universe of courses offered at Harvard, and
        explore departments and programs to browse their offerings.

        <span
          v-b-tooltip.hover
          title="Here, we see the course offerings of departments and programs across Harvard College and several of the graduate and professional schools. Clicking a departmental &quot;cloud&quot; will take you to a matrix of dots representing the courses offered in that department; click on a dot to see the full information on any individual course. These dot matrices are unstructured, lending an element of surprise to the discovery of courses."
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
import { initSetup } from 'lib/explore/universe'
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
#visWrapper {
  /deep/ {
    #visSVG {
      position: absolute;
      top: 150px;
      bottom: 0;
      left: 0;
      right: 0;
      margin: auto auto;
    }

    #visCANVAS {
      position: absolute;
      top: 150px;
      bottom: 0;
      left: 0;
      right: 0;
      margin: auto auto;
    }

    text {
      font: 10px 'IBM Plex Sans';
      font-weight: 300;
      text-anchor: start;
      fill: black;
    }

    .node--root circle {
      stroke: none;
      fill: none;
      opacity: 0;
    }

    .node--leaf circle {
      stroke: rgba(0,0,0,0);
      fill: rgba(0,0,0,0);
      cursor: pointer;
    }

    .node--leaf circle:hover{
      stroke: rgba(0,0,0,1);
      stroke-width: .5px;
      stroke-dasharray: 2,6;
      fill: rgba(200,200,200,.1);
    }

    .closeUpNode{
      cursor: pointer;
    }

    .closeUpNode circle:hover{
      stroke: rgba(0,0,0,1);
      stroke-width: 2px;
      fill: rgba(255,255,255,1);
    }

    #backText {
      font: 15px 'IBM Plex Sans';
      font-weight: 500;
      text-anchor: start;
      cursor: pointer;
    }

    #backText:hover{
      font: 15px 'IBM Plex Sans';
      font-weight: 500;
      text-anchor: start;
      text-decoration: underline;
    }

    .universeTooltip {
        position: fixed;
        text-align: left;
        width: 200px;
        padding: 5px;
        font: 12px 'IBM Plex Sans';
        background: white;
        border: 2px solid black;
        border-radius: 3px;
        pointer-events: none;
    }

    .universeTooltip:after,
    .universeTooltip:before {
      bottom: 100%;
      left: 50%;
      border: solid transparent;
      content: " ";
      height: 0;
      width: 0;
      position: absolute;
      pointer-events: none;
    }

    .universeTooltip:after {
      border-color: rgba(255, 255, 255, 0);
      border-bottom-color: #ffffff;
      border-width: 10px;
      margin-left: -10px;
    }

    .universeTooltip:before {
      border-color: rgba(0, 0, 0, 0);
      border-bottom-color: #000000;
      border-width: 13px;
      margin-left: -13px;
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
  }
}
</style>
