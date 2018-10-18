<template>
  <div
    :class="{ provisional, selected }"
    :style="computedStyle"
    class="calendar-item text-uppercase font-weight-bold p-2"
    @click="selectCourse(item)"
  >
    {{ item.title }}

    <div class="course-component">
      {{ item.component }}
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  props: {
    item: {
      type: Object,
      required: true
    },
    provisional: {
      type: Boolean,
      default: false
    },
    selected: {
      type: Boolean,
      default: false
    },
    scale: {
      type: Number,
      required: true
    },
    offset: {
      type: Number,
      required: true
    },
    height: {
      type: Number,
      default: 0
    },
    nudge: {
      type: Number,
      default: 0
    }
  },
  computed: {
    computedStyle () {
      var top = this.scale * this.offset + 65 + this.nudge
      return {
        top: top + 'px'
      }
    }
  },
  mounted () {
    // this is fine for now since we're not changing property values
    var style = this.$el.style
    style.setProperty('--height', (this.scale * this.height) + 'px')
  },
  methods: {
    ...mapActions('app', ['selectCourse'])
  }
}
</script>

<style lang="scss" scoped>
.calendar-item {
  position: absolute;
  background-color: white;
  overflow-x: hidden;
  overflow-y: hidden;
  padding-left: .5em;
  padding-right: .5em;
  font-size: 12px;
  width: 90%;
  height: var(--height);
  min-height: var(--height);
  border-radius: 4px;
  border: 2px solid black;
  background-clip: padding-box;
  cursor: pointer;

  &:hover {
    background-color: #DCDCDC;
    z-index: 10;
    height: auto;
  }

  &.selected {
    background-color: black;
    color: white;

    &:hover {
      background-color: #222;
    }
  }

  &.provisional {
    opacity: 0.5;
    z-index: 5;
  }

  .course-component {
    color: #777;
    font-weight: normal;
    white-space: nowrap;
    transform: translateX(-10px) translateY(-15px) rotate(-90deg);
    transform-origin: left center;
    position: absolute;
    top: 100%;
    left: 100%;
  }
}
</style>
