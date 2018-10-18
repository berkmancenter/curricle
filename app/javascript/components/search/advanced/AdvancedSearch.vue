<template>
  <div id="advanced-search">
    <div>
      <span id="advanced-search-schedule">
        <span
          class="advanced-search-element"
          @click="toggleSearchSchedule"
        >
          Schedule
        </span>

        <img
          class="icon-remove ml-2"
          src="/images/icons/x_black.png"
          @click="resetAdvancedSearchFilters"
        >
      </span>

      <span
        v-if="$store.state.search.searchComplete"
        id="advanced-search-filter"
      >
        <span
          id="advanced-search-filter-button"
          class="advanced-search-element ml-4"
          @click="toggleSearchFilters"
        >
          Filter
        </span>

        <img
          class="icon-remove ml-2"
          src="/images/icons/x_black.png"
          @click="resetAdvancedSearchFilters"
        >
      </span>
    </div>

    <div
      v-if="showSchedule"
      class="advanced-search mt-4"
    >
      <table style="width: 100%">
        <tr
          v-for="day in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']"
          :key="day"
        >
          <td style="width: 100px">
            <b-checkbox
              v-model="requireDay[day]"
            >
              {{ day }}
            </b-checkbox>
          </td>
          <td>
            <time-selector
              v-show="requireDay[day]"
              :enabled="requireDay[day]"
              :selstart="timeRanges[day][0]||7"
              :selend="timeRanges[day][1]||20"
              @updatedRange="(arg) => updateRange(day, arg)"
            />
          </td>
        </tr>
      </table>
    </div>

    <b-popover
      v-if="$store.state.search.searchComplete"
      :show.sync="useFilters"
      container="advanced-search"
      target="advanced-search-filter-button"
      triggers="click blur"
      placement="bottom"
    >
      <advanced-search-filters />
    </b-popover>
  </div>
</template>

<script>
import { mapActions, mapGetters, mapState } from 'vuex'
import { serializeSearch } from 'lib/util'
import _ from 'lodash'
import TimeSelector from './TimeSelector'
import AdvancedSearchFilters from './AdvancedSearchFilters'

export default {
  components: {
    AdvancedSearchFilters,
    TimeSelector
  },
  data () {
    return {
      showSchedule: false,
      showFilters: false,
      useSchedule: false,
      useFilters: false,
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
    ...mapGetters('search', ['searchSnapshot']),
    advancedSelectedDays () { return _.filter(this.requireDay).length },
    activeTimeRanges () {
      if (this.useSchedule) {
        var keys = []
        _.each(
          this.requireDay,
          (v, k) => { if (v) { keys.push(k) } }
        )
        return _.pick(this.timeRanges, keys)
      }
      return undefined
    },
    activeDays () {
      return _.filter(this.requireDay, true)
    }
  },
  watch: {
    activeTimeRanges (r) {
      this.setTimeRanges(r)
    },
    useFilters (r) {
      this.setUseFilters(r)
    },
    activeDays () {
      this.performSearch()
    }
  },
  mounted () {
    // populate default from vuex state
    if (this._times) {
      this.useSchedule = true
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
    ...mapActions('search', ['resetAdvancedSearch', 'setTimeRanges', 'setUseFilters']),
    toggleSearchSchedule () {
      this.useSchedule = true
      this.showSchedule = !this.showSchedule
      this.showFilters = false
    },
    toggleSearchFilters () {
      this.showFilters = !this.showFilters
      this.showSchedule = false
      this.useFilters = true
    },
    resetAdvancedSearchFilters () {
      this.resetAdvancedSearch()
      this.showSchedule = false
      this.showFilters = false
      this.useAdvanced = false
      this.useFilters = false

      _.each(
        _.keys(this.requireDay),
        day => {
          this.requireDay[day] = true
          this.timeRanges[day] = [7, 20]
        }
      )

      this.$router.push('/search/advanced/' + serializeSearch(this.$store.getters['search/searchSnapshot']))
    },
    updateRange (day, arg) {
      this.timeRanges[day] = arg
      this.performSearch()
    },
    performSearch () {
      this.$store.dispatch('search/saveSearchInHistory')
      this.$router.push('/search/advanced/' + serializeSearch(this.searchSnapshot))
      this.$store.dispatch('search/runKeywordSearch')
    }
  }
}
</script>

<style lang="scss" scoped>
  .advanced-search-element {
    background: black;
    color: white;
    padding: 10px 12px;
    border-radius: 4px;
    font-size: 12px;
    text-transform: uppercase;
    cursor: pointer;
  }

  img.icon-remove {
    height: 35px;
    width: auto;
    cursor: pointer;
  }

  div /deep/ .popover {
    background-color: black;
    padding: 10px;

    .arrow:after {
      border-bottom-color: black;
    }
  }
</style>
