<template lang="pug">
  <b-dropdown text="Spring 2018" class="m-md-2" v-if="name=='Semester'">
    <b-dropdown-item>Spring 2018</b-dropdown-item>
  </b-dropdown>
  <b-dropdown :text="text" class="m-md-2" v-else>
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
