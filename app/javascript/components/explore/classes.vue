<template>
  <div>
    <div id="semester-input">
      <semester-input/>
    </div>

    <div id="visContainer">
      <div
        id="courseTypeVis"
        class="text-left">
        &nbsp; Components
      </div>

      <div
        id="departmentVis"
        class="text-right">
        Departments &nbsp;
      </div>

      <div
        id="classVis"
        class="w-100 float-left"/>
    </div>
  </div>
</template>

<script>
import 'd3'
import 'jquery'
import { initSetup } from 'lib/explore/classes'
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
#visContainer {
  width: 960px;

  /deep/ {
    svg {
      display: block;
      margin: 0;
    }

    #courseTypeVis,
    #departmentVis {
      width: 50%;
      float: left;
      overflow: scroll;
      max-height:100%;
    }

    #classVis {
      overflow: scroll;
      max-height: 100%;
    }

    .departmentText:hover {
      text-decoration: underline;
    }

    .courseTypeText:hover {
      text-decoration: underline;
    }

    .departmentText,
    .departmentRect,
    .courseTypeText,
    .courseTypeRect {
      cursor: pointer;
      fill: #2C3194;
    }

    .classText {
      cursor: pointer;

      &:hover {
        text-decoration: underline;
      }
    }
  }
}

#semester-input {
  position: fixed;
  bottom: 25px;
  margin-left: 10px;
}
</style>
