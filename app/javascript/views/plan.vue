<template>
  <div class="row margin-none">
    <div class="col-md-9">
      <div> <p class= "your-tray">Your Tray</p>
        <hr>
        <div class="drop-down actions">
          <view-selector
            type="plan"
          />
          <department-selector
            v-if="viewmode.plan == 'list-view'"
          />
          <semester-selector
            v-if="viewmode.plan !== 'multi-year'"
            :mode="viewmode.plan == 'list-view' ? 'filter' : 'state'"
            :source="viewmode.plan == 'list-view' ? 'tray' : 'schedule'"
          />
        </div>
        <div>
          <plan-list-view v-if="viewmode.plan === 'list-view'"/>
          <plan-semester-view v-if="viewmode.plan === 'semester'"/>
          <plan-year-view v-if="viewmode.plan === 'multi-year'"/>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <tray v-if="trayVisible"/>
      <selected-course v-if="validCourseSelected"/>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
import axios from 'axios'

import PlanListView from 'components/plan/list-view'
import PlanYearView from 'components/plan/yearly-calendar'
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
  data () {
    return {
      categories: []
    }
  },
  computed: {
    ...mapState('app', ['trayVisible', 'viewmode']),
    ...mapGetters('user', ['validCourseSelected'])
  },
  mounted () {
    axios.get('/courses/categories').then((response) => {
      this.categories = [response.data[0]]
    })
  }
}
</script>

<style type="text/css">
  .plan .list-group-item, .calendar-sidebar .list-group-item{
    background: #E4E4E4;
    margin-bottom: 4px;
  }
  .plan .list-group-item:hover, .calendar-sidebar .list-group-item:hover{
    background: gray;
  }
  .actions i{
    font-size: 20px;
    padding-right: 15px;
  }
  .margin-none{
    margin-right: 0px !important;
    margin-left: 0px !important;
  }
</style>
