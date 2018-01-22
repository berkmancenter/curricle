<template>
  <b-dropdown
    text="Spring 2018"
    class="m-md-2"
    v-if="name === 'Semester'">
    <b-dropdown-item>Spring 2018</b-dropdown-item>
  </b-dropdown>
  <b-dropdown
    :text="text"
    class="m-md-2"
    v-else>
    <b-dropdown-item
    @click="selectItem(null)">
      All {{ name }}
    </b-dropdown-item>
    <b-dropdown-item
      v-for="item in items"
      @click="selectItem(item)">
      {{ item }}
    </b-dropdown-item>
  </b-dropdown>
</template>

<script type="text/javascript">
import { mapGetters } from 'vuex'

export default {
  props: ['title', 'items', 'field', 'name'],
  data () {
    return { text: this.title }
  },
  methods: {
    selectItem (value) {
      const sort = {
        name: this.field,
        value: value
      }
      if (value === null) {
        this.text = this.title
      } else {
        this.text = value
      }
    }
  }
}
</script>
