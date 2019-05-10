<template>
  <div class="py-5">
    <h3>Plan:</h3>

    <div class="drop-down actions">
      <department-selector
        v-show="viewMode == 'list'"
      />

      <semester-selector
        v-show="viewMode !== 'semester'"
        :mode="viewMode == 'list' ? 'filter' : 'state'"
        :source="viewMode == 'list' ? 'tray' : 'schedule'"
      />
    </div>
    <div class="clearfix" />
    <div>
      <list-view v-show="viewMode === 'list'" />
      <week-view v-show="viewMode === 'week'" />
      <semester-view v-show="viewMode === 'semester'" />
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import ListView from 'components/plan/ListView'
import WeekView from 'components/plan/WeekView'
import SemesterView from 'components/plan/SemesterView'
import DepartmentSelector from 'components/plan/DepartmentSelector'
import SemesterSelector from 'components/plan/SemesterSelector'

export default {
  components: {
    DepartmentSelector,
    ListView,
    WeekView,
    SemesterView,
    SemesterSelector
  },
  computed: {
    ...mapState('plan', ['viewMode'])
  }
}
</script>

<style type="text/css">
  .actions i {
    font-size: 20px;
    padding-right: 15px;
  }
</style>
