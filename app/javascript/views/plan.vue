<template>
  <div class="row margin-none">
    <div class="col-md-9">
      <div> <p class= "your-tray">Your Tray</p>
        <hr>
        <div class="drop-down actions">
          <view-selector/>
          <plan-filter
            :title="category.name"
            :items="category.options"
            :field="category.field"
            v-for="category in categories"
            :name="category.name"
            :key="category.id"
          />
        </div>
        <div>
          <plan-list-view v-if="viewmode === 'list-view'"/>
          <plan-semester-view v-if="viewmode === 'semester'"/>
          <plan-year-view v-if="viewmode === 'multi-year'"/>
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

import PlanFilter from 'components/plan/plan-filter'
import PlanListView from 'components/plan/list-view'
import PlanYearView from 'components/plan/yearly-calendar'
import PlanSemesterView from 'components/plan/calendar'
import SelectedCourse from 'components/plan/selected-course'
import Tray from 'components/tray/tray'
import ViewSelector from 'components/tray/view-selector'

export default {
  components: {
    PlanFilter,
    PlanListView,
    PlanYearView,
    PlanSemesterView,
    SelectedCourse,
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
      this.categories = response.data
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
