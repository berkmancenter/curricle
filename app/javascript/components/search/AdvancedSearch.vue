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
                :selstart="timeRanges[day][0]||7"
                :selend="timeRanges[day][1]||20"
                @updatedRange="(arg) => timeRanges[day] = arg"
              />
            </td>
          </tr>
        </table>
      </div>
    </div>

    <div
      v-if="showFilters"
      class="advanced-search">
      <advanced-search-filters/>
    </div>

    <div class="advanced-search-tabs">
      <span
        @click="toggleAdvancedSearch"
        :class="{'advanced-search-tab': true, selected: showAdvanced}"
      >
        Advanced Search <span v-show="useAdvanced">({{ advancedSelectedDays }})</span>
      </span>
      <span
        v-if="$store.state.search.searchComplete"
        @click="toggleSearchFilters"
        class="advanced-search-tab"
        :class="{ selected: showFilters }">
        Filter Results ({{ selectedFilterCount }})
      </span>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from 'vuex'
import _ from 'lodash'
import TimeSelector from 'components/search/TimeSelector'
import AdvancedSearchFilters from 'components/search/AdvancedSearchFilters'

export default {
  components: {
    AdvancedSearchFilters,
    TimeSelector
  },
  data () {
    return {
      showAdvanced: false,
      showFilters: false,
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
    ...mapState('search', { _times: 'timeRanges' }),
    ...mapGetters('search', ['selectedFilterCount']),
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
  mounted () {
    // populate default from vuex state
    if (this._times) {
      this.useAdvanced = true
      _.each(
        _.keys(this.requireDay),
        day => {
          this.requireDay[day] = !!this._times[day]
          if (this._times[day]) {
            this.timeRanges[day] = this._times[day]
          }
        }
      )
    }
  },
  methods: {
    ...mapActions('search', ['setTimeRanges']),
    toggleAdvancedSearch () {
      this.useAdvanced = true
      this.showAdvanced = !this.showAdvanced
      this.showFilters = false
    },
    toggleSearchFilters () {
      this.showFilters = !this.showFilters
      this.showAdvanced = false
    }
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
  cursor: pointer;
  padding: .5em;
  padding-top: 3px;
  margin: 0;
}

.advanced-search-tab.selected {
  background-color: #EEE;
}
</style>
