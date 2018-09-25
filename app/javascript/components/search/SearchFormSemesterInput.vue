<template>
  <div>
    Semester:
    <span
      id="search-semester-range"
      class="pointer">
      &nbsp;<strong>{{ rangeLabel }}</strong>&nbsp;<font-awesome-icon icon="caret-down"/>

      <b-popover
        target="search-semester-range"
        triggers="click blur"
        placement="bottom">
        <span>Select one or more semesters</span>
        <hr>
        <b-form>
          <b-row>
            <b-col class="justify-content-md-left">
              <b-form-radio-group
                v-model="searchTermStart"
                :options="optionsTermName"
                stacked
                name="search-start-term"
              />
            </b-col>
            <b-col class="justify-content-md-left">
              <b-form-select
                v-model="searchYearStart"
                :options="optionsTermYear"
                class="year-select"/>
            </b-col>
            <b-col class="justify-content-md-left">
              <b-form-checkbox v-model="searchTermUseRange">
                to
              </b-form-checkbox>
            </b-col>
            <b-col
              v-show="searchTermUseRange"
              class="justify-content-md-left"
            >
              <b-form-radio-group
                v-model="searchTermEnd"
                :options="optionsTermName"
                name="search-end-term"
                stacked/>
            </b-col>
            <b-col
              v-show="searchTermUseRange"
              class="justify-content-md-left"
            >
              <b-form-select
                v-model="searchYearEnd"
                :options="optionsTermYearEnd"
                class="year-select"/>
            </b-col>
          </b-row>
        </b-form>
      </b-popover>
    </span>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import _ from 'lodash'

export default {
  name: 'BasicSearchSemesterRange',
  components: {
    FontAwesomeIcon
  },
  data () {
    return {
      optionsTermName: [
        { text: 'Spring', value: 'Spring' },
        { text: 'Summer', value: 'Summer' },
        { text: 'Fall', value: 'Fall' }
      ],
      optionsTermYear: {}
    }
  },
  computed: {
    ...mapState('app', ['catalogYearStart', 'catalogYearEnd']),
    rangeLabel () {
      var from = this.searchTermStart + ' ' + this.searchYearStart
      var to = this.searchTermEnd + ' ' + this.searchYearEnd

      if (this.searchTermUseRange) {
        return from + ' - ' + to
      } else {
        return from
      }
    },
    optionsTermYearEnd () {
      return _.filter(
        this.optionsTermYear,
        o => {
          return this.searchTermStart === 'Fall'
            ? o.value > this.searchYearStart
            : o.value >= this.searchYearStart
        }
      )
    },
    searchTermStart: {
      get () {
        return this.$store.state.search.searchTermStart
      },
      set (value) {
        this.$store.commit('search/SET_SEARCH_TERM_START', value)
      }
    },
    searchYearStart: {
      get () {
        return this.$store.state.search.searchYearStart
      },
      set (value) {
        this.$store.commit('search/SET_SEARCH_YEAR_START', value)
      }
    },
    searchTermUseRange: {
      get () {
        return this.$store.state.search.searchTermUseRange
      },
      set (value) {
        this.$store.commit('search/SET_SEARCH_TERM_USE_RANGE', value)
      }
    },
    searchTermEnd: {
      get () {
        return this.$store.state.search.searchTermEnd
      },
      set (value) {
        this.$store.commit('search/SET_SEARCH_TERM_END', value)
      }
    },
    searchYearEnd: {
      get () {
        return this.$store.state.search.searchYearEnd
      },
      set (value) {
        this.$store.commit('search/SET_SEARCH_YEAR_END', value)
      }
    }
  },
  mounted () {
    this.optionsTermYear =
      _.map(
        _.range(this.catalogYearStart, this.catalogYearEnd + 1),
        y => { return { value: y, text: y } }
      )
  }
}
</script>

<style>
.popover {
  max-width: 100% !important;
}

.year-select {
  width: 80px !important;
}
</style>
