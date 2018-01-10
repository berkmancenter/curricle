<template>
  <span>
    <span
      id="search-field-dropdown"
      class="pointer">
      Apply to: <strong>{{ dropdownTitle }}</strong>&nbsp;<font-awesome-icon icon="caret-down"/>

      <b-popover
        target="search-field-dropdown"
        triggers="click blur"
        placement="bottom">
        <b-form-checkbox-group
          stacked
          v-model="selected"
          name="search-fields"
          :options="options"
        />
      </b-popover>
    </span>
  </span>
</template>

<script>
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'

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
      selected: this.applyTo,
      options: [
        { text: 'Title', value: 'Title' },
        { text: 'Description', value: 'Description' },
        { text: 'Instructor', value: 'Instructor', disabled: true },
        { text: 'Readings', value: 'Readings', disabled: true },
        { text: 'Course ID', value: 'Course ID', disabled: true }
      ]
    }
  },
  computed: {
    dropdownTitle () {
      switch (this.selected.length) {
        // TODO: revert this once all search fields are available
        // case this.options.length:
        case 2:
          return 'All'
        case 0:
          return 'None'
        default:
          return this.selected.join(', ')
      }
    }
  },
  watch: {
    selected: function () { this.$emit('applyFilterChange', this.selected) }
  }
}
</script>

<style scoped>
.pointer {
  cursor: pointer;
}
</style>
