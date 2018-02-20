<template>
  <div>
    <div>
      <div v-show="showAdvanced">
        <table style="width: 100%">
          <tr
            v-for="day in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']"
            :key="day"
          >
            <td style="width: 100px" >
              <b-checkbox
                v-model="requireDay[day]"
              >
                {{ day }}
              </b-checkbox>
            </td>
            <td>
              <time-selector v-show="requireDay[day]"/>
            </td>
          </tr>
        </table>
      </div>
    </div>
    <div>
      <span
        @click="useAdvanced = true; showAdvanced = !showAdvanced"
      >
        Advanced Search <span v-show="useAdvanced">({{ advancedSelectedDays }})</span>
      </span>
      <span>
        Filter Results (0)
      </span>
    </div>
  </div>
</template>

<script>
import _ from 'lodash'
import TimeSelector from 'components/search/TimeSelector'

export default {
  components: {
    TimeSelector
  },
  data () {
    return {
      showAdvanced: false,
      useAdvanced: false,
      timeRanges: {
        Mon: [7, 20],
        Tue: [7, 20],
        Wed: [7, 20],
        Thu: [7, 20],
        Fri: [7, 20]
      },
      requireDay: {
        Mon: true,
        Tue: true,
        Wed: true,
        Thu: true,
        Fri: true
      }
    }
  },
  computed: {
    advancedSelectedDays () { return _.filter(this.requireDay).length }
  }
}
</script>

<style>

</style>
