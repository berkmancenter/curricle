<template>
  <div>
    <div
      class="text-center text-uppercase"
    >
      Instructor Networks

      <h4
        class="text-uppercase font-weight-bold"
      >
        {{ submittedName }}
      </h4>
    </div>

    <div id="interfaceContainer">
      <div id="visContainer" />
    </div>

    <div id="vis-description">
      <h3>Explore:</h3>

      <p>
        Discover faculty networks of teaching and learning.
        Select an <span class="instructor">instructor</span>
        to see faculty with whom they've co-taught, connecting
        through <span class="courses">courses</span> to
        <span class="departments">departments</span>.

        <span
          v-b-tooltip.hover
          title="Instructors from different fields often explore shared interests by teaching together; this visualization explores networks of faculty by showing classes co-taught by instructors. Type the name of an instructor into the search bar and a network will appear with co-teachers. Lines connect these instructors to courses and the departments that offer them. Select course titles to learn more. Shift across instructors for new connections and patterns."
          class="pointer"
        >
          MORE&nbsp;&gt;
        </span>
      </p>

      <semester-input />

      <div
        id="searchContainer"
        class="mt-3"
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
                placeholder="Enter instructor name"
              />

              <b-input-group-append is-text>
                <img
                  class="icon pointer"
                  src="/images/icons/return_arrow.png"
                  @click="onSubmit"
                >
              </b-input-group-append>
            </b-input-group>
          </b-form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { initSetup, requestData } from 'lib/explore/instructors'
import { mapActions, mapGetters } from 'vuex'
import SemesterInput from 'components/shared/SemesterInput'

export default {
  components: {
    SemesterInput
  },
  data () {
    return {
      instructorName: '',
      submittedName: ''
    }
  },
  computed: {
    ...mapGetters('search', ['semesterStart'])
  },
  mounted () {
    initSetup(this.selectCourse)
  },
  methods: {
    ...mapActions('app', ['selectCourse']),
    onSubmit (e) {
      e.preventDefault()
      this.submittedName = this.instructorName
      requestData(this.instructorName, this.semesterStart)
    }
  }
}
</script>

<style lang="scss" scoped>
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
  .departmentText,
  .instructorText {
    cursor: pointer;
  }

  .departmentText {
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
  position: fixed;
  bottom: 25px;
  margin-left: 10px;
  width: 250px;

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

    span.departments {
      color: #00adf0;
    }
  }
}

#searchContainer {
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
