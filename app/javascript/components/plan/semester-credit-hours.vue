<template>
  <span>
    <b-row>
      <strong>{{ semester }}</strong>
    </b-row>
    <b-row :style="{ height: ((longestDuration + 1) * scale + 30) + 'px' }">
      <b-col>
        <b-row>
          <b-col class="header">
            Time
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <span
              v-for="(hr,index) in hours"
              :key="hr"
              :style="{ display: 'block', position: 'absolute', top: index * scale + 'px', width: '575%', 'border-top': '1px solid lightgray' }"
            >
              {{ hr }}
            </span>
          </b-col>
        </b-row>
      </b-col>
      <b-col
        v-for="course in courses"
        :key="course.index"
        class="day-column"
      >
        <b-row>
          <b-col class="header"/>
        </b-row>
        <b-row>
          <calendar-item
            :item="course"
            :scale="scale"
            :offset="0"
            :height="course.units_maximum"
          />
        </b-row>
      </b-col>
    </b-row>
  </span>
</template>

<script>
import _ from 'lodash'

import CalendarItem from 'components/plan/calendar-item'

export default {
  components: {
    CalendarItem
  },
  props: {
    courses: {
      type: Array,
      required: true
    },
    semester: {
      type: String,
      required: true
    }
  },
  data () {
    return {
      scale: 80
    }
  },
  computed: {
    longestDuration () {
      var duration = 0
      _.each(this.courses, c => { duration = Math.max(duration, c.units_maximum | 0) })
      return Math.max(3, duration)
    },
    hours () {
      return _.map(_.range(this.longestDuration + 1), h => h === 0 ? '' : h === 1 ? '1hr' : h + 'hr')
    }
  }
}
</script>

<style scoped>
.day-column {

}

.header {
    font-weight: bold;
    text-align: left;
}
</style>
