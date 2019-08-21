<template>
  <div>
    <div class="basic-search mb-3">
      <semester-input :allow-range="true" />

      <div class="mt-4 w-50">
        <b-input-group>
          <b-input-group-prepend is-text>
            <img
              class="icon"
              src="/images/icons/eye_black.png"
            >
          </b-input-group-prepend>

          <input
            v-model="keyword"
            type="search"
            class="search pl-0 form-control"
            placeholder="Enter a keyword"
            @keyup.enter="addActiveKeyword"
          >

          <b-input-group-append is-text>
            <basic-search-field-dropdown
              :apply-to="applyTo"
              @applyFilterChange="applyTo = $event"
            />
          </b-input-group-append>

          <b-input-group-append is-text>
            <img
              class="icon pointer"
              src="/images/icons/return_arrow.png"
              @click="addActiveKeyword"
            >
          </b-input-group-append>
        </b-input-group>
      </div>
    </div>

    <advanced-search />

    <basic-search-active-keywords />

    <basic-search-inactive-keywords />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { serializeSearch } from 'lib/util'

import AdvancedSearch from './AdvancedSearch'
import BasicSearchActiveKeywords from './BasicSearchActiveKeywords'
import BasicSearchFieldDropdown from './BasicSearchFieldDropdown'
import BasicSearchInactiveKeywords from './BasicSearchInactiveKeywords'
import SemesterInput from 'components/shared/SemesterInput'

export default {
  name: 'BasicSearch',
  components: {
    AdvancedSearch,
    BasicSearchActiveKeywords,
    BasicSearchFieldDropdown,
    BasicSearchInactiveKeywords,
    SemesterInput
  },
  data () {
    return {
      keyword: '',
      weight: 5,
      applyTo: ['TITLE', 'DESCRIPTION', 'INSTRUCTOR', 'NOTES', 'COURSE_ID']
    }
  },
  computed: {
    ...mapGetters('search', ['searchSnapshot'])
  },
  methods: {
    addActiveKeyword () {
      if (this.keyword) {
        this.$root.$emit('bv::hide::popover')
        this.$store.dispatch('search/addKeyword', { text: this.keyword, applyTo: this.applyTo, active: true })
      }

      this.keyword = ''

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
.basic-search {
  .form-control:focus {
    box-shadow: none;
  }

  span.invert {
    background: #000;
    color: #fff;
    padding: 5px 8px;
  }

  .input-group-text,
  input.search {
    background-color: #ddd;
    border: 0;
    color: black;
  }
}

::placeholder {
  color: black !important;
}

img.icon {
  height: 12px;
  width: auto;
}
</style>
