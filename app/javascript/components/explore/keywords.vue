<template>
  <div>
    <p class="text-uppercase">
      Keyword Comparisons
    </p>

    <div
      id="vis-description"
      class="mb-4"
    >
      <p>
        Visualize the appearance of terms across the curriculum by entering any two keywords and the visualization will display the courses using those words, independently or in tandem, in their titles or descriptions. To reset the visualization, simply enter new keywords at left and right.
      </p>

      <semester-input />
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
            value="subject_description"
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
  </div>
</template>

<script>
import 'd3'
import 'jquery'
import { initSetup } from 'lib/explore/keywords'
import { mapActions, mapGetters, mapMutations } from 'vuex'
import SemesterInput from 'components/shared/SemesterInput'

export default {
  components: {
    SemesterInput
  },
  data () {
    return {
      keywordOne: '',
      keywordTwo: '',
      searchBoxOne: 'Truth',
      searchBoxTwo: 'Lies'
    }
  },
  computed: {
    ...mapGetters('search', ['semesterStart']),
    ...mapGetters('user', ['courseIdStyles'])
  },
  watch: {
    semesterStart (newSemester) {
      initSetup(this.selectCourse, newSemester, this.showLoaderOverlay, this.courseIdStyles)
    }
  },
  mounted () {
    this.updateKeywords()
    initSetup(this.selectCourse, this.semesterStart, this.showLoaderOverlay, this.courseIdStyles)
  },
  methods: {
    ...mapActions('app', ['selectCourse']),
    ...mapMutations({
      showLoaderOverlay: 'search/SET_SEARCH_RUNNING'
    }),
    updateKeywords () {
      this.keywordOne = this.searchBoxOne
      this.keywordTwo = this.searchBoxTwo
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
</style>
