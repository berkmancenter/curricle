<template>
  <span
    :id="kwId"
    :key="keyword.ident"
    :class="keywordClass"
    class="text-uppercase mr-2"
  >
    <span
      @click="bodyClick"
    >
      {{ keyword.text }}
    </span>&nbsp;&nbsp;
    <font-awesome-icon
      icon="times"
      @click="closeClick"
    />
  </span>
</template>

<script>
import { mapGetters, mapState } from 'vuex'
import { serializeSearch } from 'lib/util'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import _ from 'lodash'

export default {
  components: {
    FontAwesomeIcon
  },
  props: {
    keyword: {
      type: Object,
      required: true
    }
  },
  data () {
    return {
      selected: this.keyword.applyTo,
      editing: false
    }
  },
  computed: {
    ...mapState('search', ['applyToOptions']),
    ...mapGetters('search', ['searchSnapshot']),
    keywordClass () {
      return (this.keyword.active ? 'active' : 'inactive') + '-keyword border border-dark rounded'
    },
    kwId () {
      return 'keyword-elem-' + this.keyword.ident
    },
    keywordApplyTo () {
      if (this.selected.length === this.applyToOptions.length - _.filter(this.applyToOptions, { 'disabled': true }).length) {
        return 'a'
      }
      if (this.selected.length === 1) {
        return this.selected[0].charAt(0).toLowerCase()
      }
      return '*'
    }
  },
  methods: {
    closeClick () {
      var act = this.keyword.active ? 'search/deactivateKeyword' : 'search/removeKeyword'
      this.$store.dispatch(act, this.keyword)
      this.performSearch()
    },
    bodyClick () {
      if (!this.keyword.active) {
        this.$store.dispatch('search/activateKeyword', this.keyword)
        this.performSearch()
      }
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
.inactive-keyword,
.active-keyword {
  cursor: pointer;
  display: inline-block;
  padding: 5px 10px;
  font-size: 14px;

  &:hover {
    background-color: #eee;
  }

  .applyTo {
    display: inline;
    background-color: black;
    color: white;
  }
}
</style>
