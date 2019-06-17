<template>
  <div class="row mx-0">
    <div class="col-md-12 top-header">
      <div>
        <p>Shared Schedule</p>

        <hr>

        <week-view :read-only="true" />
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import WeekView from 'components/plan/WeekView'

export default {
  components: {
    WeekView
  },
  props: {
    scheduleToken: {
      type: String,
      required: true
    }
  },
  computed: {
    ...mapState('plan', ['viewMode'])
  },
  created () {
    this.$store.commit('user/SET_SHARED_SCHEDULE_TOKEN', this.scheduleToken)
  }
}
</script>

<style type="text/css">
  .top-header {
    margin-top: 28px;
  }

  .actions i {
    font-size: 20px;
    padding-right: 15px;
  }
</style>
