<template>
  <div class="row mx-0">
    <div class="col-md-9 top-header">
      <div>
        <p>Shared Schedule</p>
        <hr>
        <div class="actions clearfix">
          <view-selector
            :show-list-view="false"
            type="plan"
          />

          <semester-selector
            v-show="viewmode.plan !== 'multi-year'"
            :mode="'state'"
            :source="'schedule'"
          />
        </div>

        <div>
          <plan-semester-view v-show="viewmode.plan === 'semester'" />
          <plan-year-view v-show="viewmode.plan === 'multi-year'" />
        </div>
      </div>
    </div>

    <div class="col-md-3 top-header">
      <the-sidebar />
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import PlanSemesterView from 'components/plan/SemesterView'
import PlanYearView from 'components/plan/MultiYearView'
import SemesterSelector from 'components/plan/SemesterSelector'
import TheSidebar from 'components/TheSidebar'
import ViewSelector from 'components/shared/ViewSelector'

export default {
  components: {
    PlanSemesterView,
    PlanYearView,
    SemesterSelector,
    TheSidebar,
    ViewSelector
  },
  props: {
    scheduleToken: {
      type: String,
      required: true
    }
  },
  computed: {
    ...mapState('app', ['viewmode'])
  },
  created () {
    this.$store.commit('user/SET_SHARED_SCHEDULE_TOKEN', this.scheduleToken)
    this.$store.commit('app/CHOOSE_SIDEBAR_VIEW', { type: 'plan', view: 'semester' })
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
