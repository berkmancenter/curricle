<template>
  <span>
    <span
      id="search-field-dropdown"
      class="pointer"
    >
      Apply to: <strong>{{ dropdownTitle }}</strong>&nbsp;<font-awesome-icon icon="caret-down" />

      <b-popover
        target="search-field-dropdown"
        triggers="click blur"
        placement="bottom"
      >
        <b-form-checkbox-group
          v-model="selected"
          :options="options"
          stacked
          name="search-fields"
        />
      </b-popover>
    </span>
  </span>
</template>

<script>
import { mapState } from 'vuex'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

export default {
  name: 'BasicSearchFieldDropdown',
  components: {
    FontAwesomeIcon
  },
  props: {
    applyTo: {
      type: Array,
      default () {
        return []
      }
    }
  },
  data () {
    return {
      selected: this.applyTo
    }
  },
  computed: {
    ...mapState('search', { options: 'applyToOptions' }),
    dropdownTitle () {
      switch (this.selected.length) {
        // TODO: revert this once all search fields are available
        // case this.options.length:
        case 5:
          return 'All'
        case 0:
          return 'None'
        default:
          return this.selected.map(field => field.charAt()).join(', ') // TODO: Return human-readable versions of the field names
      }
    }
  },
  watch: {
    selected: function () { this.$emit('applyFilterChange', this.selected) }
  }
}
</script>
