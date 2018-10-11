<template>
  <span>
    <span
      id="search-field-weight-dropdown"
      class="pointer">
      Weight: <strong>{{ sel }}</strong>&nbsp;<font-awesome-icon icon="caret-down"/>

      <b-popover
        target="search-field-weight-dropdown"
        triggers="click blur"
        placement="bottom">
        <b-form-radio-group
          v-model="sel"
          :options="options"
          stacked/>
      </b-popover>
    </span>
  </span>
</template>

<script>
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

export default {
  name: 'BasicSearchFieldWeightDropdown',
  components: {
    FontAwesomeIcon
  },
  props: {
    weight: {
      type: Number,
      default: 5
    }
  },
  data () {
    return {
      sel: this.weight,
      options: [
        { value: 1, text: '1' },
        { value: 2, text: '2' },
        { value: 3, text: '3' },
        { value: 4, text: '4' },
        { value: 5, text: '5' },
        { value: 6, text: '6' },
        { value: 7, text: '7' },
        { value: 8, text: '8' },
        { value: 9, text: '9' }
      ]
    }
  },
  watch: {
    sel: function () {
      this.$emit('weightChange', this.sel)
    }
  }
}
</script>
