<template>
  <div id="advanced-search">
    <div>
      <span
        v-if="$store.state.search.searchComplete"
        id="advanced-search-filter"
      >
        <span
          id="advanced-search-filter-button"
          class="advanced-search-element ml-4"
          tabindex="0"
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
import { mapActions, mapGetters } from 'vuex'
import { serializeSearch } from 'lib/util'
import AdvancedSearchFilters from './AdvancedSearchFilters'

export default {
  components: {
    AdvancedSearchFilters
  },
  data () {
    return {
      showSchedule: false,
      showFilters: false,
      useSchedule: false,
      useFilters: false
    }
  },
  computed: {
    ...mapGetters('search', ['searchSnapshot'])
  },
  watch: {
    useFilters (r) {
      this.setUseFilters(r)
    }
  },
  methods: {
    ...mapActions('search', ['resetAdvancedSearch', 'setUseFilters']),
    toggleSearchFilters () {
      this.showFilters = !this.showFilters
      this.showSchedule = false
      this.useFilters = true
    },
    resetAdvancedSearchFilters () {
      this.resetAdvancedSearch()
      this.showFilters = false
      this.useAdvanced = false
      this.useFilters = false

      this.$router.push('/search/advanced/' + serializeSearch(this.$store.getters['search/searchSnapshot']))
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

    .arrow::after {
      border-bottom-color: black;
    }
  }
</style>
