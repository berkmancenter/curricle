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
        <div class="plan">
          <plan-list-item/>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <tray v-if="trayVisible"/>
      <selected-course v-if="validCourseSelected"/>
    </div>
  </div>
</template>

<script type="text/javascript">
import { mapState } from 'vuex'
import Tray from 'components/tray/tray'
import ViewSelector from 'components/tray/view-selector'
import PlanFilter from 'components/plan/plan-filter'
import PlanListItem from 'components/plan/list-item'
import SelectedCourse from 'components/plan/selected-course'
import axios from 'axios'

export default {
  components: {
    PlanFilter,
    PlanListItem,
    SelectedCourse,
    ViewSelector,
    Tray
  },
  data () {
    return {
      categories: []
    }
  },
  computed: {
    ...mapState('app', ['trayVisible']),
    ...mapState('user', ['validCourseSelected'])
  },
  mounted () {
    axios.get('/courses/categories').then((response) => {
      this.categories = response.data
    })
  }
}
</script>

<style type="text/css">
  #app header .navbar-light .navbar-nav a {
    color: #000;
  }
  .your-tray, .select-course {
    color: #000;
    font-weight: bold;
    margin-bottom: 0px;
  }
  .dropdown button, .dropdown button:hover, .dropdown button:focus {
    background-color: inherit;
    color: #000;
    border: none;
  }
  .btn-secondary:not([disabled]):not(.disabled):active, .btn-secondary:not([disabled]):not(.disabled).active, .show > .btn-secondary.dropdown-toggle {
    background-color: inherit !important;
    color: #000 !important;
    border: none !important;
    box-shadow: inherit !important;
  }
  hr {
    border-color: #000 !important;
    border-width: 2px !important;
    margin-top: 0px !important;
  }
</style>
