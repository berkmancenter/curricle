<template>
  <b-dropdown :text="filters.department ? 'Department: ' + filters.department : 'Department'">
    <b-dropdown-item @click="setDepartment(null)">
      All Departments
    </b-dropdown-item>

    <b-dropdown-item
      v-for="dept in departmentsInTray"
      :key="dept"
      @click="setDepartment(dept)">
      {{ dept }}
    </b-dropdown-item>
  </b-dropdown>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'

export default {
  computed: {
    ...mapState('plan', ['filters']),
    ...mapGetters('plan', ['departmentsInTray'])
  },
  mounted () {
    this.setDepartment(this.filters.department)
  },
  methods: {
    ...mapActions('plan', ['setFilter']),
    setDepartment (dept) {
      this.setFilter({name: 'department', value: dept})
    }
  }
}
</script>

<style lang="scss" scoped>
div /deep/ {
  .dropdown-toggle, .dropdown-item {
    font-size: 12px;
  }
}
</style>
