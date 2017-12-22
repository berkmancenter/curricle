<template lang="pug">
  <b-dropdown :text="text" class="m-md-2">
    <b-dropdown-item v-for="item in items"  @click="selectItem(item)" >{{ item }}</b-dropdown-item>
  </b-dropdown>
</template>

<script type="text/javascript">
export default {
  props: ['title', 'items', 'selectedFilter', 'field', 'name'],
  data () {
    return { text: this.title }
  },
  methods: {
    selectItem (value) {
      const sort = {
        name: this.field,
        value: value
      }
      this.text = value
      this.selectedFilter(sort, this.name)
    }
  }
}
</script>
