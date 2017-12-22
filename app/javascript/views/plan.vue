<template lang="pug">
  .abc
    list-view(:selectedView="selectedView" v-if="planView=='list-view'")
    calender-view(:selectedView="selectedView" v-if="planView=='month-view'")
</template>

<script type="text/javascript">
import PlanFilter from 'components/plan/plan-filter'
import PlanListItem from 'components/plan/list-item'
import PlanDescription from 'components/plan/plan-description'
import CalenderView from 'components/plan/calender'
import ListView from 'components/plan/list-view'

export default {
  components: {
    PlanFilter,
    PlanListItem,
    PlanDescription,
    CalenderView,
    ListView
  },

  data () {
    return {
      planView: 'list-view'
    }
  },

  methods: {
    selectedView (type) {
      this.planView = type
    }
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
