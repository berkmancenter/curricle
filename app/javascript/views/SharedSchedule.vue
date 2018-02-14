<template>
  <div class="row mx-0">
    <div class="col-md-9 top-header">
      <div>
        <p>Shared Schedule</p>

        <hr>

        <semester-selector
          :mode="'state'"
          :source="'schedule'"/>

        <div>
          <plan-semester-view/>
        </div>
      </div>
    </div>

    <div class="col-md-3 top-header">
      <the-sidebar />
    </div>
  </div>
</template>

<script>
import PlanSemesterView from 'components/plan/semester-view'
import SemesterSelector from 'components/plan/semester-selector'
import TheSidebar from 'components/TheSidebar'

export default {
  components: {
    PlanSemesterView,
    SemesterSelector,
    TheSidebar
  },
  props: {
    scheduleToken: {
      type: String,
      required: true
    }
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
</style>
