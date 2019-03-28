<template>
  <div>
    <p class="text-uppercase">
      Learning Styles
    </p>

    <div
      id="vis-description"
      class="mb-4"
    >
      <p>
        Explore the types of classes available in each department. Click on your desired format, select a department, and all courses fitting that criteria will appear as a list. Click again on your selected department and format to reset the visualization.
      </p>

      <semester-input />
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
