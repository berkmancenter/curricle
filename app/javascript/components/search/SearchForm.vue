<template>
  <div>
    <div class="basic-search">
      <div class="row">
        <div class="col-md-3">
          <font-awesome-icon icon="search"/>
          <input
            v-model="keyword"
            class="search"
            placeholder="Enter Keyword"
            @keyup.enter="addActiveKeyword">
        </div>
        <div class="col-md-7 text-right">
          <basic-search-field-dropdown
            :apply-to="applyTo"
            @applyFilterChange="applyTo = $event"
          />
          &nbsp;
          <basic-search-field-weight-dropdown
            :weight="weight"
            @weightChange="weight = $event"
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
    <advanced-search/>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import AdvancedSearch from 'components/search/AdvancedSearch'
import BasicSearchActiveKeywords from 'components/search/BasicSearchActiveKeywords'
import BasicSearchFieldDropdown from 'components/search/BasicSearchFieldDropdown'
import BasicSearchFieldWeightDropdown from 'components/search/BasicSearchFieldWeightDropdown'
import BasicSearchInactiveKeywords from 'components/search/BasicSearchInactiveKeywords'
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'

import { serializeSearch } from 'lib/util'

export default {
  name: 'BasicSearch',
  components: {
    AdvancedSearch,
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
      applyTo: ['TITLE', 'DESCRIPTION', 'INSTRUCTOR', 'COURSE_ID']
    }
  },
  computed: {
    ...mapGetters('search', ['searchSnapshot'])
  },
  methods: {
    addActiveKeyword () {
      if (this.keyword) {
        this.$store.dispatch('search/addKeyword', { text: this.keyword, weight: this.weight, applyTo: this.applyTo, active: true })
      }

      this.keyword = ''
    },
    performSearch () {
      this.$store.dispatch('search/saveSearchInHistory')
      this.$router.push('/search/' + serializeSearch(this.searchSnapshot))
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
