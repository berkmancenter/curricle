<template>
  <b-dropdown
    :text="semesterLabel">
    <b-dropdown-item
      v-show="mode !== 'state'"
      @click="setSemester(null)">
      All Semesters
    </b-dropdown-item>

    <b-dropdown-item
      v-for="sem in sortedSemestersInTray"
      :key="sem"
      @click="setSemester(sem)">
      {{ sem }}
    </b-dropdown-item>
  </b-dropdown>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'
import _ from 'lodash'

export default {
  props: {
    mode: {
      type: String,
      default: 'state', // 2 modes: state or filter
      required: false
    },
    source: {
      type: String,
      default: 'schedule', // 2 sources: schedule or tray
      required: false
    }
  },
  computed: {
    ...mapState('plan', ['semester', 'filters']),
    ...mapGetters('plan', ['sortedSemestersInTray']),
    semesterLabel () {
      const semesterName = this.source === 'tray' ? this.filters.semester : this.semester

      return semesterName ? `Semester: ${semesterName}` : 'Semester: All Semesters'
    }
  },
  watch: {
    sortedSemestersInTray () {
      if (this.semester === '' || !_.includes(this.sortedSemestersInTray, this.semester)) {
        this.setSemester(this.sortedSemestersInTray[0])
      }
    }
  },
  mounted () {
    // set the initial data from either filter or state, depending on mode
    this.setSemester(this.mode === 'state' ? this.semester : this.filters.semester)
  },
  methods: {
    ...mapActions('plan', { planSetSemester: 'setSemester', setFilter: 'setFilter' }),
    setSemester (sem) {
      if (this.mode === 'state') {
        this.planSetSemester(sem)
      } else {
        this.setFilter({ name: 'semester', value: sem })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
div /deep/ {
  .dropdown-toggle,
  .dropdown-item {
    font-size: 12px;
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
