<template>
  <div>
    <p class="text-uppercase font-weight-bold">
      Learning Styles
    </p>

    <div
      id="vis-description"
      class="mb-4"
    >
      <p>
        Explore the teaching and learning format of classes across the university.
        Once you have selected the format that interests you, click on a specific
        department to display the corresponding courses. Click again on the department
        and format you have chosen to reset the visualization.
      </p>

      <semester-input />

      <course-level-input v-model="courseLevel" />
    </div>

    <div
      id="visContainer"
    >
      <div
        id="courseTypeVis"
      >
        <p
          id="courseTypeHeadline"
          class="text-uppercase"
        >
          Formats
        </p>
      </div>

      <div
        id="departmentVis"
      >
        <p
          id="departmentHeadline"
          class="text-uppercase"
        >
          Departments
        </p>
      </div>

      <div
        id="classVis"
        class="w-100 float-left"
      />
    </div>
  </div>
</template>

<script>
import 'd3'
import 'jquery'
import { initSetup } from 'lib/explore/learning-styles'
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
      courseLevel: null
    }
  },
  computed: {
    ...mapGetters('search', ['semesterEnd', 'semesterStart']),
    ...mapGetters('user', ['courseIdStyles']),
    searchFilters () {
      return [this.courseLevel, this.semesterEnd, this.semesterStart]
    },
    semesterRange () {
      const range = { start: this.semesterStart }

      if (this.semesterEnd) { range.end = this.semesterEnd }

      return range
    }
  },
  watch: {
    searchFilters: {
      handler () {
        this.refreshVisualization()
      },
      deep: true
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
    refreshVisualization () {
      initSetup(this.selectCourse, this.semesterRange, this.showLoaderOverlay, this.courseIdStyles, this.courseLevel)
    }
  }
}
</script>

<style lang="scss" scoped>
#visContainer {
  overflow: none;

  /deep/ {
    svg {
      display: block;
      margin: 0;
    }

    #courseTypeHeadline:hover {
      text-decoration: underline;
      cursor: pointer;
    }

    #departmentHeadline:hover {
      text-decoration: underline;
      cursor: pointer;
    }

    ::-webkit-scrollbar {
      display: none;
      width: 0;  /* remove scrollbar space */
      background: transparent;
    }

    #courseTypeVis,
    #departmentVis {
      width: 50%;
      float: left;
      overflow: none;
      max-height: 100%;
    }

    #courseTypeVis {
      text-align: left;
    }

    #departmentVis {
      text-align: right;
    }

    #classVis {
      width: 100%;
      float: left;
      overflow: none;
      max-height: 100%;
    }

    .departmentText,
    .departmentRect,
    .courseTypeText,
    .courseTypeRect {
      cursor: pointer;
    }

    .departmentText:hover {
      text-decoration: underline;
    }

    .courseTypeText:hover {
      text-decoration: underline;
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
  width: 80%;

  h3 {
    font-size: 18px;
  }

  p {
    font-size: 14px;

    span.formats {
      color: #d10f84;
    }

    span.departments {
      color: #00adf0;
    }
  }
}
</style>
