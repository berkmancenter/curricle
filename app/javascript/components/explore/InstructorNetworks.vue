<template>
  <div>
    <p class="text-uppercase">
      Instructor Networks
    </p>

    <div
      id="vis-description"
      class="mb-3"
    >
      <p>
        Discover faculty networks of teaching and learning from the past ten years. Type in an instructor to see faculty with whom they've co-taught, connecting through courses to subjects. Shift across instructors for new connections and patterns.
      </p>

      <semester-input />

      <course-level-input v-model="courseLevel" />
    </div>

    <div
      id="searchContainer"
      class="mb-4 px-0 col-sm-4"
    >
      <div id="search">
        <b-form @submit="onSubmit">
          <b-input-group>
            <b-input-group-prepend is-text>
              <img
                class="icon"
                src="/images/icons/eye_black.png"
              >
            </b-input-group-prepend>

            <b-form-input
              id="instructorName"
              v-model="instructorName"
              type="search"
              class="search pl-0"
              required
              autocomplete="none"
              placeholder="Enter instructor name"
            />
          </b-input-group>
        </b-form>
      </div>
    </div>

    <h4
      class="text-center text-uppercase font-weight-bold"
    >
      {{ titleName }}
    </h4>

    <div
      v-show="showNoResultsContainer"
      id="noResultsContainer"
      class="mt-5 text-center"
    >
      <p>
        This instructor has no network for the selected semester and course level.<br>
        Try one of the instructors below to get started:
      </p>

      <p
        v-for="instructor in predefinedInstructors"
        :key="instructor"
      >
        <span
          class="instructor"
          @click="forceInstructorSearch(instructor)"
        >
          {{ instructor }}
        </span>
      </p>
    </div>

    <div
      v-show="!showNoResultsContainer"
      id="interfaceContainer"
    >
      <div id="visContainer" />
    </div>
  </div>
</template>

<script>
import { initSetup, requestData } from 'lib/explore/instructor-networks'
import { mapActions, mapGetters, mapMutations } from 'vuex'
import INSTRUCTOR_NAMES_QUERY from 'graphql/InstructorNames.gql'
import Awesomplete from 'awesomplete'
import CourseLevelInput from 'components/shared/CourseLevelInput'
import SemesterInput from 'components/shared/SemesterInput'

export default {
  components: {
    CourseLevelInput,
    SemesterInput
  },
  apollo: {
    instructorNames: {
      query: INSTRUCTOR_NAMES_QUERY,
      variables () {
        return {
          semester: {
            termName: this.semesterStart.termName.toUpperCase(),
            termYear: this.semesterStart.termYear
          },
          pastYears: 10
        }
      },
      result () {
        this.awesomplete.list = this.instructorNames
      }
    }
  },
  data () {
    return {
      courseLevel: null,
      instructorName: '',
      predefinedInstructors: [
        'Leah Price',
        'Jeffrey Schnapp'
      ],
      showNoResultsContainer: false,
      titleName: ''
    }
  },
  computed: {
    ...mapGetters('search', ['semesterStart']),
    ...mapGetters('user', ['courseIdStyles'])
  },
  watch: {
    courseLevel (newCourseLevel) {
      if (this.instructorName) {
        requestData(this.instructorName, this.semesterStart, newCourseLevel)
      }
    },
    semesterStart (newSemester) {
      if (this.instructorName) {
        requestData(this.instructorName, newSemester, this.courseLevel)
      }
    }
  },
  mounted () {
    this.setupAwesomplete()

    initSetup(this.selectCourse, this.showLoaderOverlay, this.setTitleName, this.setShowNoResultsContainer, this.courseIdStyles, this.courseLevel)
  },
  methods: {
    ...mapActions('app', ['selectCourse']),
    ...mapMutations({
      showLoaderOverlay: 'search/SET_SEARCH_RUNNING'
    }),
    forceInstructorSearch (name) {
      this.instructorName = name

      requestData(this.instructorName, this.semesterStart)
    },
    onSubmit (e) {
      e.preventDefault()
      this.setShowNoResultsContainer(false)
      requestData(this.instructorName, this.semesterStart)
    },
    setTitleName (name) {
      this.titleName = name
    },
    setShowNoResultsContainer (bool) {
      this.showNoResultsContainer = bool
    },
    setupAwesomplete () {
      const input = document.getElementById('instructorName')
      this.awesomplete = new Awesomplete(input, { minChars: 4 })

      input.addEventListener('awesomplete-select', (e) => {
        this.forceInstructorSearch(e.text.value)
      })
    }
  }
}
</script>

<style lang="scss" scoped>
span.instructor {
  color: #d10f84;
  cursor: pointer;

  &:hover {
    text-decoration: underline;
  }
}

#visContainer /deep/ svg {
  display: block;
  margin: auto;

  .contributionCircle {
    fill: none;
    stroke: #000;
    stroke-width: 0.5px;
    stroke-opacity: 0.5;
  }

  .instructorLine,
  .pageLine {
    stroke-width: 1px;
    stroke-opacity: 1;
  }

  .classText,
  .classCircle,
  .classLine,
  .selectedInstructorText,
  .subjectText,
  .instructorText {
    cursor: pointer;
  }

  .subjectText {
    fill: #00adf0;
    text-anchor: end;

    &:hover {
      fill: red;
    }
  }

  .classText {
    fill: #2c3194;

    &:hover {
      fill: red;
    }
  }

  .instructorText {
    fill: #d10f84;

    :hover {
      fill: red;
    }
  }

  .selectedInstructorText:hover {
    fill: red;
  }
}

#vis-description {
  width: 80%;

  h3 {
    font-size: 18px;
  }

  p {
    font-size: 14px;

    span.instructor {
      color: #d10f84;
    }

    span.courses {
      color: #2c3194;
    }

    span.subjects {
      color: #00adf0;
    }
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

  input.search {
    border-radius: 0 0.25rem 0.25rem 0;
  }

  ::placeholder {
    color: black !important;
  }

  img.icon {
    height: 12px;
    width: auto;
  }

  .awesomplete {
    width: 80%;

    ul {
      background-color: #ddd;
      border-radius: 0 0 0.25rem 0;
      margin: -2px 0 0 0;
      padding-bottom: 10px;
      padding-right: 10px;

      li {
        cursor: pointer;

        &:hover {
          text-decoration: underline;
        }

        mark {
          background: inherit;
          color: #d10f84;
          padding: 0;
        }
      }
    }

    span {
      display: none;
    }
  }
}
</style>
