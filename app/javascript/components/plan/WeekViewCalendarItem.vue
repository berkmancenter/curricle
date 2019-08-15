<template>
  <div
    :class="{ conflicted, provisional, selected, hidden }"
    :style="computedStyle"
    class="calendar-item text-uppercase font-weight-bold p-2"
    @click="selectCourse(item)"
  >
    {{ item.title }}

    <course-action
      v-if="!readOnly"
      :course-id="item.id"
      :invert="selected"
      :type="courseActionType"
    />

    <div class="course-component">
      {{ item.component }}
    </div>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'
import CourseAction from 'components/shared/CourseAction.vue'

export default {
  components: {
    CourseAction
  },
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
    conflicted: {
      type: Boolean,
      default: false
    },
    hidden: {
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
    },
    conflictInfo: {
      type: Object,
      default () {
        return { conflictCount: 0, position: 0 }
      }
    },
    readOnly: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    ...mapGetters('user', ['courseIdImported']),
    computedStyle () {
      const top = this.scale * this.offset + 65 + this.nudge
      const position = this.conflictInfo.position
      let width = 90

      if (this.conflictInfo.conflictCount !== 0) {
        width = width / (this.conflictInfo.conflictCount + 1)
      }

      return {
        top: top + 'px',
        width: width + '%',
        left: width * position + '%'
      }
    },
    courseActionType () {
      if (this.courseIdImported(this.item.id)) {
        return 'imported'
      } else {
        return 'schedule'
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
  padding-left: 0.5em;
  padding-right: 0.5em;
  font-size: 12px;
  width: 90%;
  height: var(--height);
  min-height: var(--height);
  border-radius: 4px;
  border: 2px solid black;
  background-clip: padding-box;
  cursor: pointer;

  &:hover {
    background-color: #dcdcdc;
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

  &.conflicted {
    background-color: #ffc0cb;

    &.selected,
    &:hover {
      background-color: #ff91a4;
    }
  }

  &.hidden {
    border-color: #999;
    color: #999;
    font-style: italic;
  }

  .course-component {
    color: #777;
    font-style: normal;
    font-weight: normal;
    white-space: nowrap;
    transform: translateX(-10px) translateY(-15px) rotate(-90deg);
    transform-origin: left center;
    position: absolute;
    top: 100%;
    left: 100%;
  }

  .course-action {
    position: absolute;
    bottom: 0;
    left: 10px;
  }
}
</style>
