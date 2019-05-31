<template>
  <b-dropdown :text="'Department: ' + dropdownLabel">
    <b-dropdown-item @click="setDepartment(null)">
      All Departments
    </b-dropdown-item>

    <b-dropdown-item
      v-for="dept in departmentsInTray"
      :key="dept"
      @click="setDepartment(dept)"
    >
      {{ dept }}
    </b-dropdown-item>
  </b-dropdown>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'

export default {
  computed: {
    ...mapState('plan', ['filters']),
    ...mapGetters('plan', ['departmentsInTray']),
    dropdownLabel () {
      return this.filters.department ? this.filters.department : 'All Departments'
    }
  },
  mounted () {
    this.setDepartment(this.filters.department)
  },
  methods: {
    ...mapActions('plan', ['setFilter']),
    setDepartment (dept) {
      this.setFilter({ name: 'department', value: dept })
    }
  }
}
</script>

<style lang="scss" scoped>
div /deep/ {
  .dropdown-toggle,
  .dropdown-item {
    font-size: 12px;
    text-align: left;
    white-space: normal;
  }

  .btn-secondary,
  .btn-secondary.dropdown-toggle {
    background-color: inherit;
    color: inherit;
    border: none;
    padding-left: 0;
  }
}
</style>
