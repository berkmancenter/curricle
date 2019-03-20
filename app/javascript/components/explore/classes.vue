<template>
  <div>
    <div
      class="text-center text-uppercase"
    >
      Select a Format and Department

      <h4
        class="text-uppercase font-weight-bold"
      >
        Learning Styles
      </h4>
    </div>

    <div
      id="visContainer"
    >
      <div
        id="courseTypeVis"
      >
        <h5
          id="courseTypeHeadline"
        >
          Formats
        </h5>
      </div>

      <div
        id="departmentVis"
      >
        <h5
          id="departmentHeadline"
        >
          Departments
        </h5>
      </div>

      <div
        id="classVis"
        class="w-100 float-left"
      />
    </div>

    <div
      id="vis-description"
    >
      <h3>Explore:</h3>

      <p>
        Explore courses by selecting <span class="formats">
          formats
        </span>
        (class types) and <span class="departments">
          departments
        </span>
        (subjects and courses of study).

        <span
          v-b-tooltip.hover
          title="This visualization will help you explore the types of classes that are available in each department, from lecture to core studio to field experience. In the data, class types are called &quot;formats.&quot; In the left column, find your desired format, and look in the right column to select your desired department. Once you have selected both a department and format, all courses fitting that criteria will appear as a list. From this list, you can select the course titles to explore more information about the courses. Click on the Department and Format to reset the visualization and start again."
          class="pointer"
        >
          MORE&nbsp;&gt;
        </span>
      </p>

      <semester-input />
    </div>
  </div>
</template>

<script>
import 'd3'
import 'jquery'
import { initSetup } from 'lib/explore/classes'
import { mapActions, mapGetters, mapMutations } from 'vuex'
import SemesterInput from 'components/shared/SemesterInput'

export default {
  components: {
    SemesterInput
  },
  computed: {
    ...mapGetters('search', ['semesterStart']),
    ...mapGetters('user', ['courseIdInTray'])
  },
  watch: {
    semesterStart (newSemester) {
      initSetup(this.selectCourse, newSemester, this.showLoaderOverlay, this.courseIdInTray)
    }
  },
  mounted () {
    initSetup(this.selectCourse, this.semesterStart, this.showLoaderOverlay, this.courseIdInTray)
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
  position: fixed;
  bottom: 6%;
  margin-left: 10px;
  width: 200px;

  h3 {
    font-size: 18px;
  }

  p {
    font-size: 14px;

    span.formats {
      color: #f0cf61;
    }

    span.departments {
      color: #32b67a;
    }
  }
}
</style>
