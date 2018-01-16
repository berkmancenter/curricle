<template lang="pug">
  .abc
    list-view(:selectedView="selectedView" :trayVisible="trayVisible" :resultSet="resultSet" v-if="planView=='list-view'")
    calendar(:selectedView="selectedView" :trayVisible="trayVisible" :resultSet="resultSet" v-if="planView=='month-view'", )
    yearly-calendar(:selectedView="selectedView" :trayVisible="trayVisible" :resultSet="resultSet" v-if="planView=='year-view'")
</template>

<script type="text/javascript">
import { mapState } from 'vuex'
import PlanFilter from 'components/plan/plan-filter'
import PlanListItem from 'components/plan/list-item'
import PlanDescription from 'components/plan/plan-description'
import Calendar from 'components/plan/calendar'
import YearlyCalendar from 'components/plan/yearly-calendar'
import ListView from 'components/plan/list-view'

export default {
  components: {
    PlanFilter,
    PlanListItem,
    PlanDescription,
    Calendar,
    YearlyCalendar,
    ListView
  },

  computed: {
      ...mapState('app', {
        trayVisible: 'trayVisible',
        planView: 'viewmode'
      })
  },
  
  props: [ 'resultSet'],

  methods: {
    selectedView: type => this.$store.commit('app/CHOOSE_SIDEBAR_VIEW', type)
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
