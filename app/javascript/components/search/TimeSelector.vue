<template>
  <div class="time-selector">
    <vue-slider
      v-model="selrange"
      tooltip="always"
      :height="4"
      :lazy="true"
      :piecewise="true"
      :data="values"
      :min="1"
      :max="24"
      :interval="1"
      :show="enabled"
      :disabled="!enabled"
      :formatter="formatTime"
    />
  </div>
</template>

<script>
import { prettyTime } from 'lib/util'
import _ from 'lodash'
import vueSlider from 'vue-slider-component'

export default {
  components: {
    vueSlider
  },
  props: {
    rangestart: {
      type: Number,
      default: 7
    },
    rangeend: {
      type: Number,
      default: 20
    },
    selstart: {
      type: Number,
      required: true
    },
    selend: {
      type: Number,
      required: true
    },
    enabled: {
      type: Boolean,
      default: true
    }
  },
  data () {
    return {
      selrange: []
    }
  },
  computed: {
    values () {
      return _.range(this.rangestart, this.rangeend + 1)
    }
  },
  watch: {
    selrange (r) {
      this.$emit('updatedRange', r)
    },
    selstart (s) {
      this.selrange[0] = s
    },
    selend (s) {
      this.selrange[1] = s
    }
  },
  mounted () {
    this.selrange[0] = this.selstart || this.rangestart
    this.selrange[1] = this.selend || this.rangeend
  },
  methods: {
    formatTime: (t) => prettyTime(t)
  }
}
</script>

<style>
.vue-slider-component .vue-slider-tooltip-wrap.vue-slider-tooltip-top .vue-slider-tooltip:before {
  display: none;
}
.vue-slider-component .vue-slider-tooltip-wrap.vue-slider-tooltip-top {
  top: 20px;
}
</style>
