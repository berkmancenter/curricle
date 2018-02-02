<template>
  <div class="bar-bg">
    <span
      class="bar-display"
      v-for="(bar,idx) in bars"
      :key="idx"
      :style="computedStyle(bar)"
    />
  </div>
</template>

<script>
export default {
  props: {
    bars: {
      type: Array,
      required: true
    },
    startTime: {
      type: Number,
      default: 8
    },
    endTime: {
      type: Number,
      default: 17
    }
  },
  computed: {
    unitWidth () { return 40 / (this.endTime - this.startTime) }
  },
  methods: {
    computedStyle (bar) {
      if (bar && bar.length === 2) {
        var left = Math.max(bar[0] - this.startTime, 0)
        var width = bar[1] - Math.max(this.startTime - bar[0], 0)
        var style = {
          left: (left * this.unitWidth) + 'px',
          width: (width * this.unitWidth) + 'px'
        }
        return style
      }
    }
  }
}
</script>

<style>
.bar-bg {
  margin-top: 9px;
  margin-left: 8px;
  background-color: #CCC;
  height: 4px;
  width: 40px;
  display: block;
  position: absolute;
}
.bar-display {
  height: 4px;
  background-color: black;
  position: absolute;
  border-radius: 1px;
  /* border: 1px solid black; */
}
</style>
