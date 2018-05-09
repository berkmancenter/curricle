<template>
  <span
    id="sort-by-dropdown"
    class="pointer">
    Sort by:
    <strong>{{ sortByLabel }}</strong>&nbsp;<font-awesome-icon icon="caret-down"/>

    <b-popover
      ref="popover"
      placement="bottom"
      target="sort-by-dropdown"
      triggers="click blur">
      <b-form-radio-group
        v-model="selected"
        :options="sortByOptions"
        buttons
        button-variant="outline-dark"
        stacked
        name="sort-fields"/>
    </b-popover>
  </span>
</template>

<script>
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'
import { mapState } from 'vuex'
import _ from 'lodash'

export default {
  components: {
    FontAwesomeIcon
  },
  data () {
    return {
      selected: ''
    }
  },
  computed: {
    ...mapState('search', ['sortBy', 'sortByOptions']),
    sortByLabel () {
      return _.find(this.sortByOptions, ['value', this.sortBy]).text
    }
  },
  watch: {
    selected: function () {
      this.$refs.popover.$emit('close')
      this.$store.dispatch('search/changeSortBy', this.selected)
    }
  }
}
</script>

<style lang="scss" scoped>
.pointer {
  cursor: pointer;
}
</style>
