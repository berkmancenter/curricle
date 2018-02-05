<template>
  <div
    :class="{'calendar-item': true, provisional, selected }"
    :style="computedStyle"
    @click="selectCourse(item)">
    <strong>{{ item.external_course_id }}</strong>
    <br>
    {{ item.title }}
    <br>
    <strong>
      {{ item.academic_group }}
      <br>
      {{ item.subject }} {{ item.catalog_number }}
    </strong>
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
      var top = this.scale * this.offset + 25 + this.nudge
      return {
        top: top + 'px',
        'border-top': '10px solid ' + (this.item.department_color || '#000')
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

<style>
.calendar-item {
  position: absolute;
  background-color: #DCDCDC;
  overflow-x: hidden;
  overflow-y: hidden;
  padding-left: .5em;
  padding-right: .5em;
  font-size: 12px;
  width: 90%;
  height: var(--height);
  min-height: var(--height);
  border-radius: 5px;
  border: 1px solid rgba(0,0,0,0.3);
  background-clip: padding-box;
  box-shadow: 0 0 10px rgba(32,32,32,0.5);
}

.calendar-item:hover {
  background-color: #C0C0C0;
  z-index: 10;
  box-shadow: 0 0 15px black;
  height: auto;
}

.calendar-item.selected {
  background-color: #f5f7de;
  box-shadow: 0 0 15px #4f6477;
}

.calendar-item.selected:hover {
  background-color: #b0b29e;
}

.calendar-item.provisional {
  opacity: 0.5;
  z-index: 5;
}
</style>
