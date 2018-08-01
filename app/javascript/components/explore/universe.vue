<template>
  <div id="visWrapper">
    <canvas id="visCANVAS"/>

    <svg id="visSVG">
      <g/>
    </svg>
  </div>
</template>

<script>
import 'd3'
import 'jquery'
import { initSetup } from 'lib/explore/universe'
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
#visWrapper {
  /deep/ {
    #visSVG {
      position: absolute;
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      margin: auto auto;
    }

    #visCANVAS {
      position: absolute;
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      margin: auto auto;
    }

    text {
      font: 10px 'IBM Plex Sans';
      font-weight: 300;
      text-anchor: middle;
      fill: black;
    }

    .node--root circle {
      stroke: none;
      fill: none;
      opacity: 0;
    }

    .node--leaf circle {
      stroke: rgba(0,0,0,0);
      fill: rgba(0,0,0,0);
      cursor: pointer;
    }

    .node--leaf circle:hover{
      stroke: rgba(0,0,0,1);
      stroke-width: .5px;
      stroke-dasharray: 2,6;
      fill: rgba(200,200,200,.1);
    }

    .closeUpNode{
      cursor: pointer;
    }

    .closeUpNode circle:hover{
      stroke: rgba(0,0,0,1);
      stroke-width: 2px;
      fill: rgba(255,255,255,1);
    }

    #backText {
      font: 15px 'IBM Plex Sans';
      font-weight: 500;
      text-anchor: start;
      cursor: pointer;
    }

    #backText:hover{
      font: 15px 'IBM Plex Sans';
      font-weight: 500;
      text-anchor: start;
      text-decoration: underline;
    }

    .universeTooltip {
        position: fixed;
        text-align: left;
        width: 200px;
        padding: 5px;
        font: 12px 'IBM Plex Sans';
        background: white;
        border: 2px solid black;
        border-radius: 3px;
        pointer-events: none;
    }

    .universeTooltip:after,
    .universeTooltip:before {
      bottom: 100%;
      left: 50%;
      border: solid transparent;
      content: " ";
      height: 0;
      width: 0;
      position: absolute;
      pointer-events: none;
    }

    .universeTooltip:after {
      border-color: rgba(255, 255, 255, 0);
      border-bottom-color: #ffffff;
      border-width: 10px;
      margin-left: -10px;
    }

    .universeTooltip:before {
      border-color: rgba(0, 0, 0, 0);
      border-bottom-color: #000000;
      border-width: 13px;
      margin-left: -13px;
    }
  }
}
</style>
