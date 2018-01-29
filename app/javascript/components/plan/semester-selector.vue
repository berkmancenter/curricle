<template>
  <b-dropdown
    :text="theSemester ? 'Semester: ' + theSemester : 'Semester'"
    class="m-md-2"
  >
    <b-dropdown-item
      @click="setSemester(null)"
      v-if="mode !== 'state'">
      All Semesters
    </b-dropdown-item>
    <b-dropdown-item
      v-for="sem in theSemesters"
      :key="sem"
      @click="setSemester(sem)"
    >
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
  data () {
    return {
      theSemester: ''
    }
  },
  computed: {
    ...mapState('plan', ['semester', 'filters']),
    ...mapGetters('plan', ['sortedSemestersInSchedule', 'sortedSemestersInTray']),
    theSemesters () {
      return this.source === 'tray' ? this.sortedSemestersInTray : this.sortedSemestersInSchedule
    }
  },
  watch: {
    sortedSemestersInSchedule () {
      if (this.semester === '' || !_.includes(this.sortedSemestersInSchedule, this.semester)) {
        this.setSemester(this.sortedSemestersInSchedule[0])
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
      this.theSemester = sem
      if (this.mode === 'state') {
        this.planSetSemester(sem)
      } else {
        this.setFilter({ name: 'semester', value: sem })
      }
    }
  }
}
</script>
