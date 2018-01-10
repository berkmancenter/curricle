<template>
  <div>
    <div class="row">
      <div class="col-md-8">
        <basic-search @keywordsUpdated="keywords = $event"/>
        <br>
        <curricle-search :keywords="keywords"/>
      </div>
      <div class="col-md-4"/>
    </div>
  </div>
</template>

<script>
import BasicSearch from '../components/BasicSearch.vue'
import CurricleSearch from '../components/CurricleSearch.vue'

export default {
  components: {
    BasicSearch,
    CurricleSearch
  },
  data () {
    return {
      keywords: []
    }
  }
}
</script>
