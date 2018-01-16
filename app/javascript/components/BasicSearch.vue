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
           :applyTo="applyTo"
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
    <basic-search-active-keywords
      :active-keywords="activeKeywords"
      @deactivateKeyword="deactivateKeyword($event)"
    />
    <br>
    <basic-search-inactive-keywords
      :inactive-keywords="inactiveKeywords"
      @removeKeyword="removeKeyword($event)"
    />
  </div>
</template>

<script>
import BasicSearchActiveKeywords from './BasicSearchActiveKeywords.vue'
import BasicSearchFieldDropdown from './BasicSearchFieldDropdown.vue'
import BasicSearchFieldWeightDropdown from './BasicSearchFieldWeightDropdown.vue'
import BasicSearchInactiveKeywords from './BasicSearchInactiveKeywords.vue'
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
      applyTo: ['Title', 'Description', 'Instructor'],
      activeKeywords: [],
      inactiveKeywords: []
    }
  },
  methods: {
    addActiveKeyword () {
      if (this.keyword) {
        this.activeKeywords.push({ text: this.keyword, weight: this.weight, applyTo: this.applyTo })
      }

      this.keyword = ''
    },
    deactivateKeyword (index) {
      this.inactiveKeywords.push(this.activeKeywords[index])
      this.activeKeywords.splice(index, 1)
    },
    removeKeyword (index) {
      this.inactiveKeywords.splice(index, 1)
    },
    performSearch () {
      this.$emit('keywordsUpdated', this.activeKeywords)
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
