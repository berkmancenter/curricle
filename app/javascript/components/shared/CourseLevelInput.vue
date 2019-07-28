<template>
  <b-form inline>
    <label>
      Course Level:

      <b-form-select
        :options="options"
        :value="value"
        class="ml-2"
        @change="changeHandler"
      />
    </label>
  </b-form>
</template>

<script>
export default {
  props: {
    value: {
      type: String,
      default: null
    }
  },
  data () {
    return {
      options: [
        { value: null, text: 'All' },
        { value: 'UGRDGRAD', text: 'For Undergraduate and Graduate Students' },
        { value: 'GRADCOURSE', text: 'Graduate Course' },
        { value: 'PRIMGRAD', text: 'Primarily for Graduate Students' },
        { value: 'PRIMUGRD', text: 'Primarily for Undergraduate Students' }
      ]
    }
  },
  methods: {
    changeHandler (value) {
      this.$emit('input', value)
    }
  }
}
</script>
