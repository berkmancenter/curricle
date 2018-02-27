<template>
  <div>
    <div>
      <div
        v-if="showAdvanced"
        class="advanced-search">
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
              <time-selector
                v-show="requireDay[day]"
                @updatedRange="(arg) => timeRanges[day] = arg"
              />
            </td>
          </tr>
        </table>
      </div>
    </div>
    <div class="advanced-search-tabs">
      <span
        @click="useAdvanced = true; showAdvanced = !showAdvanced"
        :class="{'advanced-search-tab': true, selected: showAdvanced}"
      >
        Advanced Search <span v-show="useAdvanced">({{ advancedSelectedDays }})</span>
      </span>
      <span
        :class="{'advanced-search-tab': true, selected: false}"
      >
        Filter Results (0)
      </span>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
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
    advancedSelectedDays () { return _.filter(this.requireDay).length },
    activeTimeRanges () {
      if (this.useAdvanced) {
        var keys = []
        _.each(
          this.requireDay,
          (v, k) => { if (v) { keys.push(k) } }
        )
        return _.pick(this.timeRanges, keys)
      }
      return undefined
    }
  },
  watch: {
    activeTimeRanges (r) {
      this.setTimeRanges(r)
    }
  },
  methods: {
    ...mapActions('search', ['setTimeRanges'])
  }
}
</script>

<style>
.advanced-search {
  background-color: #EEE;
  padding: 1em 2em 1em 1em;
}

.advanced-search-tabs {
  margin: auto;
  width: 300px;
}

.advanced-search-tab {
  background-color: #CCC;
  padding: .5em;
  padding-top: 3px;
  margin: 0;
}

.advanced-search-tab.selected {
  background-color: #EEE;
}
</style>
