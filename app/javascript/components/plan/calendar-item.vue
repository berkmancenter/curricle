<template>
  <div
    class="calendar-item"
    :style="computedStyle"
    @click="selectCourse(item.id)">
    {{ item.title }}
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
    scale: {
      type: Number,
      required: true
    },
    offset: {
      type: Number,
      default: 0
    }
  },
  computed: {
    computedStyle () {
      return {
        height: this.scale * this.item.day[3] + 'px',
        top: this.scale * Math.max(this.item.day[2] - this.offset, 0) + 'px'
      }
    }
  },
  methods: {
    ...mapActions('user', ['selectCourse'])
  }
}
</script>

<style>
.calendar-item {
  position: absolute;
  background-color: lightgray;
  border: 1px solid black;
  overflow-x: hidden;
  overflow-y: hidden;
}

.calendar-item:hover {
    background-color: gray;
}
</style>
