<template>
  <div class="facet">
    <h5>{{ facet.title }}:</h5>

    <div class="facet-list mb-2">
      <div
        v-for="item in items"
        :key="item.id"
        class="facet-item clearfix">
        <div class="pull-left">
          <label class="mb-1">
            <input
              :value="item.id"
              :checked="item.selected"
              type="checkbox"
              @change="toggleCheckbox">
            {{ truncate(item.value) }}
          </label>
        </div>

        <div class="count pull-right">
          {{ item.count }}
        </div>
      </div>
    </div>

    <p v-if="Object.keys(items).length > 1">
      <span
        class="pointer"
        @click="selectAll">
        <strong>
          Select All
        </strong>
      </span>

      <br>

      <span
        class="pointer"
        @click="clearAll">
        <strong>
          Clear
        </strong>
      </span>
    </p>
  </div>
</template>

<script>
export default {
  props: {
    facet: {
      type: Object,
      required: true
    }
  },
  computed: {
    items () {
      return this.$store.getters['search/sortedFilters'](this.facet.key)
    }
  },
  methods: {
    truncate (str) {
      const maxLength = 15

      if (str.length > maxLength) {
        return `${str.substring(0, maxLength)}...`
      } else {
        return str
      }
    },
    toggleCheckbox (e) {
      this.$store.commit(
        'search/FACET_SET_ITEM_SELECTION',
        {
          facet: this.facet.key,
          itemId: e.target.value,
          selected: e.target.checked
        }
      )
    },
    selectAll () {
      this.$store.dispatch(
        'search/facetSetAllItemSelections',
        {
          facet: this.facet.key,
          selected: true
        }
      )
    },
    clearAll () {
      this.$store.dispatch(
        'search/facetSetAllItemSelections',
        {
          facet: this.facet.key,
          selected: false
        }
      )
    }
  }
}
</script>

<style scoped>
h5 {
  font-size: 14px;
  margin-bottom: 10px;
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
</style>
