<template>
  <div>
    <div class="row">
      <div class="col-md-8">
        <basic-search @keywordsUpdated="keywords = $event"/>
        <br>
        <curricle-search :keywords="keywords" />
      </div>
      <div class="col-md-4 sidebar" v-if="trayVisible">
        <tray/>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import Tray from '../components/tray/tray.vue'
import BasicSearch from '../components/BasicSearch.vue'
import CurricleSearch from '../components/CurricleSearch.vue'
import axios from 'axios'

export default {
  components: {
    BasicSearch,
    CurricleSearch,
    Tray
  },

  computed: {
    ...mapState('app', ['trayVisible'])
  },
  props: [ 'searchedResults'],

  mounted () {
    // this.filterCategories()
    // this.getCoursesByDate()
    // this.getCoursesByYear()
    // this.getUserCourses()
  },

  data () {
    return {
      keywords: [],
      results: [],
      // filteredResults: [],
      categories: []
    }
  }

}
</script>

<style type="text/css">
  .sidebar{
    margin-top: 28px;
  }
</style>
