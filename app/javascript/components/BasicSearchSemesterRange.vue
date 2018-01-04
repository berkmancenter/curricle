<template>
  <div>
    <span
      id="search-semester-rage"
      class="pointer">
      <strong>&nbsp;{{ optionsTermYearRange }}</strong>&nbsp;<font-awesome-icon icon="caret-down"/>

      <b-popover
        style="max-width: 500px;"
        class="mw-500"
        target="search-semester-rage"
        triggers="click blur"
        placement="bottom">
        <span>Select one or more semesters</span>
        <hr>
        <b-form
          inline
          class="inline-content">
          <b-form-checkbox-group
            stacked
            class="mx-2 justify-content-md-left"
            v-model="selectedFromTermName"
            name="search-fields"
            :options="optionsTermName"
          />
          <b-form-select
            v-model="selectedFromTermYear"
            :options="optionsTermYear"
            class="mx-2" />
          <b-form-checkbox
            id="checkbox1"
            class="mx-2"
            v-model="range"
            value="yes"
            unchecked-value="no">
            to
          </b-form-checkbox>
          <b-form-checkbox-group
            stacked
            class="mx-2"
            v-model="selectedToTermName"
            name="search-fields"
            :options="optionsTermName"
          />
          <b-form-select
            v-model="selectedToTermYear"
            :options="optionsTermYear"
            class="mx-2" />
        </b-form>
      </b-popover>
    </span>
  </div>
</template>

<script>
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'

export default {
  name: 'BasicSearchSemesterRange',
  components: {
    FontAwesomeIcon
  },
  data () {
    return {
      selectedFromTermName: ['Fall'],
      selectedToTermName: ['Spring'],
      optionsTermName: [
        { text: 'Spring', value: 'Spring' },
        { text: 'Fall', value: 'Fall' },
        { text: 'Summer', value: 'Summer' }
      ],

      selectedFromTermYear: '2017',
      selectedToTermYear: '2018',
      optionsTermYear: [
        { value: '2017', text: '2017' },
        { value: '2018', text: '2018' }
      ],

      range: 'no'
    }
  },
  computed: {
    optionsTermYearRange () {
      var from = this.selectedFromTermName + ' ' + this.selectedFromTermYear
      var to = this.selectedToTermName + ' ' + this.selectedToTermYear
      if (this.range === 'yes') {
        return from + ' - ' + to
      } else {
        return from
      }
    }

  }
}
</script>

<style scoped>
.pointer {
  cursor: pointer;
}
.inline-content {
  display: flex;
  width: auto
}
.popover {
  max-width: 500px !important;
}
</style>
