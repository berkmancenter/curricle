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
        The word “university” comes from the Latin word “universitas,” which
        means totality, and Course Universe allows you to explore that totality
        at the level of the curriculum as a whole. Zoom out and survey the
        university’s entire course catalog. Zoom in and examine individual
        departments. Zoom in further to explore specific courses. The courses
        and departments loaded into your current schedule are highlighted.
      </p>

      <semester-input />

      <course-level-input v-model="courseLevel" />
    </div>

    <div
      id="searchContainer"
      class="mb-4 px-0 col-sm-4"
    >
      <div id="search">
        <b-form @submit="performSearch">
          <b-input-group>
            <b-input-group-prepend is-text>
              <img
                class="icon"
                src="/images/icons/eye_black.png"
              >
            </b-input-group-prepend>

            <input
              v-model="searchQuery"
              type="search"
              class="search pl-0 form-control"
              placeholder="Search courses"
            >

            <b-input-group-append is-text>
              <img
                class="icon pointer"
                src="/images/icons/return_arrow.png"
                @click="performSearch"
              >
            </b-input-group-append>
          </b-input-group>
        </b-form>
      </div>
    </div>

    <div
      id="noResults"
      style="display: none;"
    >
      <strong>
        No results found for that search.
      </strong>
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
import _ from 'lodash'
import { initSetup, requestFirstData } from 'lib/explore/course-universe'
import { mapActions, mapGetters, mapMutations } from 'vuex'
import CourseLevelInput from 'components/shared/CourseLevelInput'
import SemesterInput from 'components/shared/SemesterInput'

export default {
  components: {
    CourseLevelInput,
    SemesterInput
  },
  data () {
    return {
      courseLevel: null,
      searchQuery: ''
    }
  },
  computed: {
    ...mapGetters('plan', ['scheduledCoursesBySemester']),
    ...mapGetters('search', ['semesterStart', 'semesterStartString']),
    ...mapGetters('user', ['userCoursesScheduleIds']),
    args () {
      return {
        courseLevel: this.courseLevel,
        departmentsInSchedule: this.departmentsInSchedule,
        selectCourse: this.selectCourse,
        semesterStart: this.semesterStart,
        showLoaderOverlay: this.showLoaderOverlay,
        userCoursesScheduleIds: this.userCoursesScheduleIds
      }
    },
    departmentsInSchedule () {
      const courses = this.scheduledCoursesBySemester[this.semesterStartString]
      return _(courses).map('classAcademicOrgDescription').uniq().value()
    }
  },
  watch: {
    args: {
      handler () {
        this.refreshVisualization()
      },
      deep: true
    },
    userCoursesScheduleIds () {
      this.refreshVisualization()
    }
  },
  mounted () {
    this.refreshVisualization()
  },
  methods: {
    ...mapActions('app', ['selectCourse']),
    ...mapMutations({
      showLoaderOverlay: 'search/SET_SEARCH_RUNNING'
    }),
    performSearch (e) {
      e.preventDefault()
      requestFirstData(this.searchQuery)
    },
    refreshVisualization () {
      initSetup(this.args)
    }
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

      &.scheduled {
        fill: rgba(100, 119, 232, 0.4);
      }
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

    .closeUpNode circle {
      &.clicked {
        fill: rgba(155, 155, 155, 1);
      }

      &.scheduled {
        fill: rgba(100, 119, 232, 1);
      }
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

#searchContainer /deep/ {
  .form-control:focus {
    box-shadow: none;
  }

  .input-group-text,
  input.search {
    background-color: #ddd;
    border: 0;
    color: black;
  }

  ::placeholder {
    color: black !important;
  }

  img.icon {
    height: 12px;
    width: auto;
  }
}
</style>
