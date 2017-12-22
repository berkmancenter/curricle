<template>
  <div>
    <div class="row">
      <div class="col-md-8">
        <basic-search @keywordUpdated="keyword = $event"/>
        <br>
        <curricle-search :keyword="keyword"/>
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
      keyword: ''
    }
  }
}
</script>
