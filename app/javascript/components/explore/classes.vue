<template>
  <div id="visContainer">
    <div id="courseTypeVis">&nbsp; Components</div>
    <div id="departmentVis">Departments &nbsp;</div>
    <div id="classVis"/>
  </div>
</template>

<script>
import 'd3'
import 'jquery'
import { initSetup } from 'lib/explore/classes'
import { mapActions, mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters('search', ['semesterStart'])
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
  div /deep/ {
    svg {
      display: block;
      margin: 0;
  }
  #courseTypeVis, #departmentVis{
    width: 50%;
    float:left;
    overflow: scroll;
    max-height:100%;
  }
  #courseTypeVis{
    text-align: left;
  }
  #departmentVis{
    text-align: right;
  }
  #classVis{
    width: 100%;
    float:left;
    overflow: scroll;
    max-height:100%;
  }
  .departmentText:hover {
    text-decoration: underline;
  }
  .courseTypeText:hover {
    text-decoration: underline;
  }
  .departmentText, .departmentRect, .courseTypeText, .courseTypeRect{
    cursor:pointer;
    fill: #2C3194;
  }

  .classText {
    cursor: pointer;

    &:hover {
      text-decoration: underline;
    }
  }
}
</style>
