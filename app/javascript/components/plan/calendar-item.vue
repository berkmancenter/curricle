<template>
  <div
    class="calendar-item"
    :style="computedStyle"
    @click="selectCourse(item.id)">
    <strong>{{ item.id }}</strong>
    <br>
    {{ item.title }}
    <p>
      <strong>
        {{ item.academic_group }}
        <br>
        {{ item.subject }} {{ item.catalog_number }}
      </strong>
    </p>
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
        top: (this.scale * Math.max(this.item.day[2] - this.offset, 0) - 15) + 'px',
        'border-top': '10px solid ' + (this.item.department_color || '#000')
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
  overflow-x: hidden;
  overflow-y: hidden;
  padding-left: .5em;
  padding-right: .5em;
  font-size: 12px;
  width: 90%;
}

.calendar-item:hover {
    background-color: gray;
}
</style>
