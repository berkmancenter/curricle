<template>
  <div class="row mx-0">
    <div class="col-md-9 top-header">
      <div>
        <p>Shared Schedule</p>
        <hr>
        <div class="actions clearfix">
          <semester-selector
            v-show="viewMode !== 'semester'"
            :mode="'state'"
            :source="'schedule'"
          />
        </div>

        <div>
          <week-view v-show="viewMode === 'week'" />
          <semester-view v-show="viewMode === 'semester'" />
        </div>
      </div>
    </div>

    <div class="col-md-3 top-header">
      <the-tray />
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import WeekView from 'components/plan/WeekView'
import SemesterView from 'components/plan/SemesterView'
import SemesterSelector from 'components/plan/SemesterSelector'
import TheTray from 'components/TheTray'

export default {
  components: {
    WeekView,
    SemesterView,
    SemesterSelector,
    TheTray
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
