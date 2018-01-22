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
  </div>
</template>

<script>
import BasicSearchActiveKeywords from 'components/BasicSearchActiveKeywords'
import BasicSearchFieldDropdown from 'components/BasicSearchFieldDropdown'
import BasicSearchFieldWeightDropdown from 'components/BasicSearchFieldWeightDropdown'
import BasicSearchInactiveKeywords from 'components/BasicSearchInactiveKeywords'
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'

export default {
  name: 'BasicSearch',
  components: {
    BasicSearchActiveKeywords,
    BasicSearchFieldDropdown,
    BasicSearchFieldWeightDropdown,
    BasicSearchInactiveKeywords,
    FontAwesomeIcon
  },
  data () {
    return {
      keyword: '',
      weight: 5,
      applyTo: ['Title', 'Description', 'Instructor']
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
      this.$store.dispatch('search/runSearch')
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
