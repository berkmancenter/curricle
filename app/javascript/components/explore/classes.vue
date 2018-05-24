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
import { mapActions } from 'vuex'

export default {
  mounted () {
    initSetup(this.selectCourse)
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
  #visContainer{
    height:100vh;
    overflow: hidden;
    position: relative;
  }
  #courseTypeVis, #departmentVis{
    width: 50%;
    float:left;
    overflow: scroll;
    max-height:100%;
  }
  #courseTypeVis{
    text-align: left;
    /*margin-right: 10px;*/
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
    /*fill: #2C3194;*/
    text-decoration: underline;
  }
  .courseTypeText:hover {
    /*fill: #2C3194;*/
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
