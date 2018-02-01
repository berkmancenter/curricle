<template>
  <b-dropdown
    text="Spring 2018"
    class="m-md-2"
    v-show="name === 'Semester'">
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
      :key="item"
      @click="selectItem(item)">
      {{ item }}
    </b-dropdown-item>
  </b-dropdown>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      required: true
    },
    items: {
      type: Array,
      required: true
    },
    field: {
      type: String,
      default: ''
    },
    name: {
      type: String,
      required: true
    }
  },
  data () {
    return { text: this.title }
  },
  methods: {
    selectItem (value) {
      if (value === null) {
        this.text = this.title
      } else {
        this.text = value
      }
    }
  }
}
</script>
