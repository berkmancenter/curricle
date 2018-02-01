<template>
  <div class="row mx-0">
    <div class="col-md-9 top-header">
      <div> <p class= "your-tray">Your Tray</p>
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
        <div>
          <plan-list-view v-show="viewmode.plan === 'list-view'"/>
          <plan-semester-view v-show="viewmode.plan === 'semester'"/>
          <plan-year-view v-show="viewmode.plan === 'multi-year'"/>
        </div>
      </div>
    </div>
    <div class="col-md-3 top-header">
      <tray v-show="trayVisible"/>
      <selected-course v-show="validCourseSelected"/>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'

import PlanListView from 'components/plan/list-view'
import PlanYearView from 'components/plan/multi-year-view'
import PlanSemesterView from 'components/plan/semester-view'
import SelectedCourse from 'components/shared/SelectedCourse'
import DepartmentSelector from 'components/plan/department-selector'
import SemesterSelector from 'components/plan/semester-selector'
import Tray from 'components/tray/tray'
import ViewSelector from 'components/shared/view-selector'

export default {
  components: {
    DepartmentSelector,
    PlanListView,
    PlanYearView,
    PlanSemesterView,
    SelectedCourse,
    SemesterSelector,
    Tray,
    ViewSelector
  },
  computed: {
    ...mapState('app', ['trayVisible', 'viewmode']),
    ...mapGetters('user', ['validCourseSelected'])
  }
}
</script>

<style type="text/css">
  .actions i{
    font-size: 20px;
    padding-right: 15px;
  }
  .top-header {
    margin-top: 28px;
  }
</style>
