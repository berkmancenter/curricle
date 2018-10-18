<template>
  <div
    v-if="hasData"
  >
    <div
      v-for="(day,index) in week"
      v-show="!condensed || day.timeBar"
      :key="index"
      :class="{ conflicted: conflicts[index] }"
    >
      <div
        :class="{ inactive: !(day.timeBar && day.timeBar.length) }"
      >
        <span
          class="day-name"
        >
          {{ day.abbrev }}
        </span>

        {{ day.timePretty }}
      </div>
    </div>
  </div>
  <div
    v-else
  >
    Schedule TBD
  </div>
</template>

<script>
/* A comment about the data structure used here:
 *
 * The "days" parameter is generally a list of lists, however we know
 * that we will need to support more complexity as we move forward
 * (for example, some courses may meet at different times different
 * weeks of the term.
 *
 * This is not the common case, however, so we will assume that in a
 * normal course situation the course meets at the same time or times
 * for each day of the week.  The days structure will then be an array
 * of arrays, with offset 0 being Monday, offset 1 being Tuesday and so-on.
 * In the case of a more complex course description, we will fall back to
 * an array of objects which will more fully describe the course schedule.
 *
 * We will write helper functions to turn these object descriptions into a
 * week-by-week description of this type, so potentially this specific
 * component will be a lower-level component that will display a single week's
 * structure as needed, with a higher-level component to handle more
 * complicated cases and the interface of selecting weeks, etc.
 */

import _ from 'lodash'
import { prettyTime } from 'lib/util'

export default {
  props: {
    schedule: {
      type: Object,
      required: true
    },
    conflicts: {
      type: Array,
      required: false,
      default: () => { return [] }
    },
    condensed: {
      type: Boolean,
      default: false
    },
    scaleWidth: {
      type: Number,
      required: false,
      default: 0
    }
  },
  computed: {
    /* turns the input params into the more sensible data structure for use by this component */
    days () {
      // handling only the 'simple' schedule type; add logic for split schedules and the like here
      if (this.schedule.type === 'simple') {
        return this.schedule.data
      }
      return []
    },
    week () {
      var abbrev = ['MON', 'TUE', 'WED', 'THU', 'FRI']

      return _.zipWith(
        abbrev,
        this.days,
        (ab, day) => {
          var hasTime = day && day.length

          return {
            abbrev: ab,
            timePretty: hasTime ? _.map(day, mtg => {
              return prettyTime(mtg[0]) + '-' + prettyTime(mtg[0] + mtg[1])
            }).join(',') : '',
            timeBar: day
          }
        }
      )
    },
    hasData () { return this.days && this.days.length }
  }
}
</script>

<style scoped>
.inactive {
  color: gray;
}

.conflicted {
  color: darkred;
}

.day-name {
  display: inline-block;
  width: 32px;
}
</style>
