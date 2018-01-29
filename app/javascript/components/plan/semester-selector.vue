<template>
  <b-dropdown
    :text="semester ? 'Semester: ' + semester : 'Choose Semester'"
    class="m-md-2"
  >
    <b-dropdown-item
      v-for="sem in sortedSemestersInSchedule"
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
  computed: {
    ...mapState('plan', ['semester']),
    ...mapGetters('plan', ['sortedSemestersInSchedule'])
  },
  watch: {
    sortedSemestersInSchedule () {
      if (this.semester === '' || !_.includes(this.sortedSemestersInSchedule, this.semester)) {
        this.setSemester(this.sortedSemestersInSchedule[0])
      }
    }
  },
  methods: {
    ...mapActions('plan', ['setSemester'])
  }
}
</script>
