<template>
  <div
    :class="{'calendar-item': true, provisional }"
    :style="computedStyle"
    @click="selectCourse(item.id)">
    <strong>{{ item.external_course_id }}</strong>
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
    provisional: {
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
        height: this.scale * this.height + 'px',
        top: top + 'px',
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
  z-index: 10;
}

.calendar-item.provisional {
  opacity: 0.5;
  z-index: 5;
}
</style>
