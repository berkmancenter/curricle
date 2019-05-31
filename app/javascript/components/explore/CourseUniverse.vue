<template>
  <div>
    <p class="text-uppercase">
      Course Universe
    </p>

    <div
      id="vis-description"
      class="mb-4"
    >
      <p>
        Get an overview of the universe of the departments and programs at Harvard, and then click in to explore the classes offered by that department. This visualization is randomly structured, enjoy the element of surprise!
      </p>

      <semester-input />
    </div>

    <div id="visWrapper">
      <canvas id="visCANVAS" />

      <svg id="visSVG">
        <g />
      </svg>
    </div>
  </div>
</template>

<script>
import 'd3'
import 'jquery'
import { initSetup } from 'lib/explore/course-universe'
import { mapActions, mapGetters, mapMutations } from 'vuex'
import SemesterInput from 'components/shared/SemesterInput'

export default {
  components: {
    SemesterInput
  },
  computed: {
    ...mapGetters('search', ['semesterEnd', 'semesterStart'])
  },
  watch: {
    semesterEnd (newSemester) {
      initSetup(this.selectCourse, this.semesterStart, newSemester, this.showLoaderOverlay)
    },
    semesterStart (newSemester) {
      initSetup(this.selectCourse, newSemester, this.semesterEnd, this.showLoaderOverlay)
    }
  },
  mounted () {
    initSetup(this.selectCourse, this.semesterStart, this.semesterEnd, this.showLoaderOverlay)
  },
  methods: {
    ...mapActions('app', ['selectCourse']),
    ...mapMutations({
      showLoaderOverlay: 'search/SET_SEARCH_RUNNING'
    })
  }
}
</script>

<style lang="scss" scoped>
#visWrapper {
  position: relative;

  /deep/ {
    #visSVG,
    #visCANVAS {
      position: absolute;
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      margin: 0 auto;
    }

    text {
      font: 10px 'IBM Plex Sans', sans-serif;
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
      stroke: rgba(0, 0, 0, 0);
      fill: rgba(0, 0, 0, 0);
      cursor: pointer;
    }

    .node--leaf circle:hover {
      stroke: rgba(0, 0, 0, 1);
      stroke-width: 0.5px;
      stroke-dasharray: 2, 6;
      fill: rgba(200, 200, 200, 0.1);
    }

    .closeUpNode {
      cursor: pointer;
    }

    .closeUpNode circle:hover {
      stroke: rgba(0, 0, 0, 1);
      stroke-width: 2px;
      fill: rgba(255, 255, 255, 1);
    }

    #backText {
      font: 15px 'IBM Plex Sans', sans-serif;
      font-weight: 500;
      text-anchor: start;
      cursor: pointer;
    }

    #backText:hover {
      font: 15px 'IBM Plex Sans', sans-serif;
      font-weight: 500;
      text-anchor: start;
      text-decoration: underline;
    }

    .universeTooltip {
      position: fixed;
      text-align: left;
      width: 200px;
      padding: 5px;
      font: 12px 'IBM Plex Sans', sans-serif;
      background: white;
      border: 2px solid black;
      border-radius: 3px;
      pointer-events: none;
    }

    .universeTooltip::after,
    .universeTooltip::before {
      bottom: 100%;
      left: 50%;
      border: solid transparent;
      content: " ";
      height: 0;
      width: 0;
      position: absolute;
      pointer-events: none;
    }

    .universeTooltip::after {
      border-color: rgba(255, 255, 255, 0);
      border-bottom-color: #fff;
      border-width: 10px;
      margin-left: -10px;
    }

    .universeTooltip::before {
      border-color: rgba(0, 0, 0, 0);
      border-bottom-color: #000;
      border-width: 13px;
      margin-left: -13px;
    }
  }
}

#vis-description {
  width: 80%;

  h3 {
    font-size: 18px;
  }

  p {
    font-size: 14px;
  }
}
</style>