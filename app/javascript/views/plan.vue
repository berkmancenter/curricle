<template>
  <div>
    <p class= "your-tray">Your Tray</p>
    <hr>
    <div class="drop-down actions">
      <view-selector
        type="plan"
      />
      <department-selector
        v-show="viewmode.plan == 'list-view'"
      />
      <semester-selector
        v-show="viewmode.plan !== 'multi-year'"
        :mode="viewmode.plan == 'list-view' ? 'filter' : 'state'"
        :source="viewmode.plan == 'list-view' ? 'tray' : 'schedule'"
      />
    </div>
    <div class="clearfix"/>
    <div>
      <plan-list-view v-show="viewmode.plan === 'list-view'"/>
      <plan-semester-view v-show="viewmode.plan === 'semester'"/>
      <plan-year-view v-show="viewmode.plan === 'multi-year'"/>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import PlanListView from 'components/plan/list-view'
import PlanYearView from 'components/plan/multi-year-view'
import PlanSemesterView from 'components/plan/semester-view'
import DepartmentSelector from 'components/plan/department-selector'
import SemesterSelector from 'components/plan/semester-selector'
import ViewSelector from 'components/shared/view-selector'

export default {
  components: {
    DepartmentSelector,
    PlanListView,
    PlanYearView,
    PlanSemesterView,
    SemesterSelector,
    ViewSelector
  },
  computed: {
    ...mapState('app', ['viewmode'])
  }
}
</script>

<style type="text/css">
  .actions i{
    font-size: 20px;
    padding-right: 15px;
  }
</style>
