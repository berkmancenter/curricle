<template>
  <b-dropdown
    :text="department ? 'Department: ' + department : 'Department'"
    class="m-md-2"
  >
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
import { mapGetters, mapActions } from 'vuex'

export default {
  data () {
    return {
      department: ''
    }
  },
  computed: {
    ...mapGetters('plan', ['departmentsInTray'])
  },
  methods: {
    ...mapActions('plan', ['setFilter']),
    setDepartment (dept) {
      this.department = dept
      this.setFilter({name: 'department', value: dept})
    }
  }
}
</script>
