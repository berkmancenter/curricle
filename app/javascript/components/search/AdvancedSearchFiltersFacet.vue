<template>
  <div class="facet">
    <h5>{{ facet.title }}</h5>

    <div class="facet-list mb-2">
      <div
        v-for="item in items"
        :key="item.id"
        class="facet-item clearfix">
        <div class="float-left label-container">
          <label class="mb-1 text-white text-uppercase pointer">
            <input
              :value="item.id"
              :checked="item.selected"
              type="checkbox"
              @change="toggleCheckbox">
            {{ item.value }}
          </label>
        </div>

        <div class="count float-right text-white">
          {{ item.count }}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { serializeSearch } from 'lib/util'

export default {
  components: {
    serializeSearch
  },
  props: {
    facet: {
      type: Object,
      required: true
    }
  },
  computed: {
    ...mapGetters('search', ['searchSnapshot']),
    items () {
      return this.$store.getters['search/sortedFilters'](this.facet.key)
    }
  },
  methods: {
    toggleCheckbox (e) {
      this.$store.commit(
        'search/FACET_SET_ITEM_SELECTION',
        {
          facet: this.facet.key,
          itemId: e.target.value,
          selected: e.target.checked
        }
      )

      this.performSearch()
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
h5 {
  font-size: 14px;
  margin-bottom: 10px;
  color: white;
}

.count {
  color: #888;
  padding-right: 15px;
}

.facet {
  font-size: 12px;
}

.facet-list {
  max-height: 200px;
  overflow: scroll;
}

.pointer {
  cursor: pointer;
}

.label-container {
  max-width: 60%;
  overflow: scroll;

  label {
    white-space: nowrap;
  }
}

input[type="checkbox"] {
  display: none;
}
</style>
