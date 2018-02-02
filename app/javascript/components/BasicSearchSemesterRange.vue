<template>
  <div>
    <span id="the-catalog"><strong>The Catalog</strong></span>
    <span
      id="search-semester-range"
      class="pointer">
      &nbsp;{{ optionsTermYearRange }}&nbsp;<font-awesome-icon icon="caret-down"/>

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
                stacked
                v-model="selectedSearchTermStart"
                name="search-start-term"
                :options="optionsTermName"
              />
            </b-col>
            <b-col class="justify-content-md-left">
              <b-form-select
                class="year-select"
                v-model="selectedSearchYearStart"
                :options="optionsTermYear" />
            </b-col>
            <b-col class="justify-content-md-left">
              <b-form-checkbox
                id="checkbox1"
                v-model="selectedSearchUseRange"
                :value="1"
                :unchecked-value="0">
                to
              </b-form-checkbox>
            </b-col>
            <b-col
              v-show="selectedSearchUseRange"
              class="justify-content-md-left"
            >
              <b-form-radio-group
                stacked
                v-model="selectedSearchTermEnd"
                name="search-end-term"
                :options="optionsTermName"
              />
            </b-col>
            <b-col
              v-show="selectedSearchUseRange"
              class="justify-content-md-left"
            >
              <b-form-select
                class="year-select"
                v-model="selectedSearchYearEnd"
                :options="optionsTermYearEnd" />
            </b-col>
          </b-row>
        </b-form>
      </b-popover>
    </span>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'
import _ from 'lodash'

const searchProps = ['searchTermStart', 'searchTermEnd', 'searchYearStart', 'searchYearEnd', 'searchUseRange']

export default {
  name: 'BasicSearchSemesterRange',
  components: {
    FontAwesomeIcon
  },
  data () {
    return {
      selectedSearchTermStart: '',
      selectedSearchTermEnd: '',
      selectedSearchYearStart: '',
      selectedSearchYearEnd: '',
      selectedSearchUseRange: false,
      optionsTermName: [
        { text: 'Spring', value: 'Spring' },
        { text: 'Summer', value: 'Summer' },
        { text: 'Fall', value: 'Fall' }
      ],
      optionsTermYear: {}
    }
  },
  computed: {
    ...mapState('search', searchProps),
    ...mapState('app', ['catalogYearStart', 'catalogYearEnd']),
    optionsTermYearRange () {
      var from = this.selectedSearchTermStart + ' ' + this.selectedSearchYearStart
      var to = this.selectedSearchTermEnd + ' ' + this.selectedSearchYearEnd
      if (this.selectedSearchUseRange) {
        return from + ' - ' + to
      } else {
        return from
      }
    },
    optionsTermYearEnd () {
      return _.filter(
        this.optionsTermYear,
        o => {
          return this.selectedSearchTermStart === 'Fall'
            ? o.value > this.selectedSearchYearStart
            : o.value >= this.selectedSearchYearStart
        }
      )
    }
  },
  mounted () {
    this.optionsTermYear =
      _.map(
        _.range(this.catalogYearStart, this.catalogYearEnd + 1),
        y => { return { value: y, text: y } }
      )
    _.each(searchProps, p => { this['selected' + _.upperFirst(p)] = this[p] })
  }
}
</script>

<style>
.popover {
  max-width: 100% !important;
}
.year-select {
  width: 5vw;
}
</style>
