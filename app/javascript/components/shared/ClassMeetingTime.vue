<template>
  <span>
    <table v-if="hasData">
      <tr
        v-for="(day,index) in week"
        :key="index"
        v-if="!condensed || day.timeBar"
      >
        <td>
          {{ day.timePretty }}
        </td>
        <td
          :style="{ active: day.timeBar }"
        >
          {{ day.abbrev }}
        </td>
        <td>
          (timebar)
        </td>
      </tr>
    </table>
    <table v-else>
      <tr>
        <td>
          Schedule TBD
        </td>
      </tr>
    </table>
  </span>
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

function prettyTime (time) {
  // hours or fraction of hours

  var hours = Math.floor(time)
  var mins = 60 * (time - hours)
  var isPm = hours >= 12
  var ret = isPm ? hours - 12 : hours

  if (mins) {
    ret += ':' + mins
  }

  ret += isPm ? 'pm' : 'am'

  return ret
}

function timeFormat (start, duration) {
  // this will turn things prettier, like "3pm - 4pm"

  // for now, just pass-thru

  return prettyTime(start) + '-' + prettyTime(start + duration)
}

export default {
  props: {
    days: {
      type: Array,
      required: true
    },
    conflicts: {
      type: Array,
      required: false,
      default: () => []
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
    week () {
      var abbrev = ['M', 'T', 'W', 'T', 'F']

      return _.zipWith(
        abbrev,
        this.days,
        (ab, day) => {
          var hasTime = day && day.length

          return {
            abbrev: ab,
            timePretty: hasTime ? timeFormat(day[2], day[3]) : '',
            timeBar: hasTime ? [day[2], day[3]] : undefined
          }
        }
      )
    },
    hasData () { return this.days && this.days.length }
  }
}
</script>

<style>
</style>
