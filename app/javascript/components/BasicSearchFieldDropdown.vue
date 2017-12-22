<template>
  <div>
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
  </div>
</template>

<script>
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'

export default {
  name: 'BasicSearchFieldDropdown',
  components: {
    FontAwesomeIcon
  },
  data () {
    return {
      selected: ['Title', 'Description', 'Instructor', 'Readings', 'Course ID'],
      options: [
        { text: 'Title', value: 'Title' },
        { text: 'Description', value: 'Description' },
        { text: 'Instructor', value: 'Instructor' },
        { text: 'Readings', value: 'Readings' },
        { text: 'Course ID', value: 'Course ID' }
      ]
    }
  },
  computed: {
    dropdownTitle () {
      switch (this.selected.length) {
        case this.options.length:
          return 'All'
        case 0:
          return 'None'
        default:
          return this.selected.join(', ')
      }
    }
  }
}
</script>

<style scoped>
.pointer {
  cursor: pointer;
}
</style>
