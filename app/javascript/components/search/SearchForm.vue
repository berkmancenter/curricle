<template>
  <div>
    <div class="basic-search">
      <div class="row">
        <div class="col-md-3">
          <font-awesome-icon icon="search"/>
          <input
            class="search"
            placeholder="Enter Keyword"
            v-model="keyword"
            @keyup.enter="addActiveKeyword">
        </div>
        <div class="col-md-7 text-right">
          <basic-search-field-dropdown
            :apply-to="applyTo"
            @applyFilterChange="applyTo = $event"
          />
          &nbsp;
          <basic-search-field-weight-dropdown
            @weightChange="weight = $event"
            :weight="weight"
          />
        </div>
        <div class="col-md-2 text-right">
          <span
            class="invert pointer"
            @click="addActiveKeyword">
            <font-awesome-icon icon="plus"/>
          </span>
          <span
            class="invert pointer"
            @click="performSearch">
            Apply
          </span>
        </div>
      </div>
    </div>
    <basic-search-active-keywords/>
    <br>
    <basic-search-inactive-keywords/>
    <br>
    <div v-show="showAdvanced">
      <table style="width: 100%">
        <tr
          v-for="day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']"
          :key="day"
        >
          <td style="width: 100px" >
            <b-checkbox
              v-model="enabled[day]"
            >
              {{ day }}
            </b-checkbox>
          </td>
          <td>
            <time-selector :enabled="enabled[day]"/>
          </td>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
import BasicSearchActiveKeywords from 'components/search/BasicSearchActiveKeywords'
import BasicSearchFieldDropdown from 'components/search/BasicSearchFieldDropdown'
import BasicSearchFieldWeightDropdown from 'components/search/BasicSearchFieldWeightDropdown'
import BasicSearchInactiveKeywords from 'components/search/BasicSearchInactiveKeywords'
import TimeSelector from 'components/search/TimeSelector'
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'

export default {
  name: 'BasicSearch',
  components: {
    BasicSearchActiveKeywords,
    BasicSearchFieldDropdown,
    BasicSearchFieldWeightDropdown,
    BasicSearchInactiveKeywords,
    FontAwesomeIcon,
    TimeSelector
  },
  data () {
    return {
      keyword: '',
      weight: 5,
      applyTo: ['TITLE', 'DESCRIPTION', 'INSTRUCTOR', 'COURSE_ID'],
      showAdvanced: true,
      advanced: [],
      enabled: {
        Monday: true,
        Tuesday: true,
        Wednesday: true,
        Thursday: true,
        Friday: true
      }
    }
  },
  methods: {
    addActiveKeyword () {
      if (this.keyword) {
        this.$store.dispatch('search/addKeyword', { text: this.keyword, weight: this.weight, applyTo: this.applyTo, active: true })
      }

      this.keyword = ''
    },
    performSearch () {
      this.$store.dispatch('search/runKeywordSearch')
    }
  }
}
</script>

<style lang="scss" scoped>
.basic-search {
  border-bottom: 2px solid #000;
  margin-bottom: 10px;
  margin-top: 20px;
  padding-bottom: 5px;

  input.search {
    border: none;
    margin-left: 5px;
    width: 120px;

    &:focus {
      outline: none;
    }
  }

  span.invert {
    background: #000;
    color: #fff;
    padding: 5px 8px;
  }
}

.pointer {
  cursor: pointer;
}
</style>
