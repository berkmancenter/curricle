<template>
  <div>
    <p class="text-uppercase font-weight-bold">
      Keyword Comparisons
    </p>

    <div
      id="vis-description"
      class="mb-4"
    >
      <p>
        Enter two keywords at the left and right to visualize the courses in which
        these two words intersect from the standpoint of class formats, academic
        disciplines, or specific class offerings. To reset the visualization,
        simply enter new keywords.
      </p>

      <semester-input />

      <course-level-input v-model="courseLevel" />
    </div>

    <h4 class="text-center text-uppercase font-weight-bold">
      {{ keywordOne }} / {{ keywordTwo }}
    </h4>

    <div id="interfaceContainer">
      <div id="dimContainer">
        <ul>
          <li
            class="dimSelect"
            value="component"
          >
            Learning Styles
          </li> |

          <li
            class="dimSelect active"
            value="subjectDescription"
          >
            Subjects
          </li> |

          <li
            id="dimClass"
            class="dimSelect"
            value="title"
          >
            Classes
          </li>
        </ul>
      </div>

      <div id="searchContainer">
        <div
          id="searchOne"
          class="searchBox"
        >
          <input
            id="searchBoxOne"
            v-model="searchBoxOne"
            class="searchBoxInput"
            type="text"
            placeholder="search term..."
            @keyup.enter="updateKeywords"
          >

          <button
            id="searchBoxOneButton"
            class="searchBoxButton"
          >
            &gt;
          </button>
        </div>

        <div
          id="searchTwo"
          class="searchBox"
        >
          <button
            id="searchBoxTwoButton"
            class="searchBoxButton"
          >
            &lt;
          </button>

          <input
            id="searchBoxTwo"
            v-model="searchBoxTwo"
            class="searchBoxInput"
            type="text"
            placeholder="search term..."
            @keyup.enter="updateKeywords"
          >
        </div>
      </div>

      <div id="visContainer" />
    </div>

    <div
      v-show="showNoResultsContainer"
      id="no-results"
      class="text-center"
    >
      <strong>
        No results found for that search.
      </strong>
    </div>
  </div>
</template>

<script>
import 'd3'
import 'jquery'
import { initSetup } from 'lib/explore/keyword-comparisons'
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
      keywordOne: '',
      keywordTwo: '',
      searchBoxOne: 'Truth',
      searchBoxTwo: 'Lies',
      showNoResultsContainer: false
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
    this.updateKeywords()
    this.refreshVisualization()
  },
  methods: {
    ...mapActions('app', ['selectCourse']),
    ...mapMutations({
      showLoaderOverlay: 'search/SET_SEARCH_RUNNING'
    }),
    refreshVisualization () {
      initSetup(this.selectCourse, this.semesterRange, this.showLoaderOverlay, this.courseIdStyles, this.setShowNoResultsContainer, this.courseLevel)
    },
    updateKeywords () {
      this.keywordOne = this.searchBoxOne
      this.keywordTwo = this.searchBoxTwo
    },
    setShowNoResultsContainer (bool) {
      this.showNoResultsContainer = bool
    }
  }
}
</script>

<style lang="scss" scoped>
#interfaceContainer {
  position: relative;

  /deep/ {
    svg {
      display: block;
      margin: 0;
      width: 100%;
    }

    .leftSelected {
      fill: green;
    }

    .rightSelected {
      fill: orange;
    }

    .rightSelected,
    .leftSelected {
      /* text-decoration: underline; */
      font-weight: 300;
      cursor: pointer;

      &:hover {
        text-decoration: underline;
      }
    }

    .centerText {
      cursor: pointer;
      text-shadow:
        -1px -1px 0 rgba(255, 255, 255, 0.5),
        1px -1px 0 rgba(255, 255, 255, 0.5),
        -1px 1px 0 rgba(255, 255, 255, 0.5),
        1px 1px 0 rgba(255, 255, 255, 0.5);
    }

    .centerText:hover {
      text-decoration: underline;
    }

    .centerSelected {
      text-decoration: underline;
      font-weight: 700;
      cursor: pointer;
    }

    .insideText:hover {
      text-decoration: underline;
      cursor: pointer;
    }

    /* ------ Search Style ------- */

    .searchBox {
      position: absolute;
      width: 137px;
      background: none;
    }

    #searchBoxOne {
      text-align: right;
      color: #d10f84;
    }

    #searchBoxTwo {
      color: #00adf0;
    }

    #searchBoxOneButton {
      text-align: right;
    }

    .searchBoxInput {
      outline: none;
      font-family: 'IBM Plex Sans', sans-serif;
      border: none;
      border-bottom: 1px solid black;
      font-size: 14px;
      font-weight: 300;
      width: 90px;
    }

    .searchBoxButton {
      outline: none;
      font-family: 'IBM Plex Sans', sans-serif;
      border: none;
      font-size: 14px;
      background: white;
    }

    /* ------ Dim. Select Style ------- */

    #dimContainer {
      height: 0;
      padding-top: 30px;
      text-align: center;
      min-width: 600px;
    }

    #dimContainer ul {
      list-style-type: none;
      margin: auto;
      padding: 0;
      vertical-align: middle;
    }

    #dimContainer li {
      display: inline;
      cursor: pointer;
    }

    .dimSelect:hover {
      text-decoration: underline;
    }

    .dimSelect.active {
      text-decoration: underline;
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

#no-results {
  margin-top: -120px;
}
</style>
