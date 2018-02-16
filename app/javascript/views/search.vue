<template>
  <div class="row mx-0">
    <div class="col-md-9 d-flex flex-column">
      <basic-search />
      <br>
      <curricle-search />
    </div>
    <div class="col-md-3 top-header">
      <the-sidebar />
    </div>
  </div>
</template>

<script>
import BasicSearch from 'components/BasicSearch'
import CurricleSearch from 'components/CurricleSearch'
import TheSidebar from 'components/TheSidebar'

export default {
  components: {
    BasicSearch,
    CurricleSearch,
    TheSidebar
  }
}
</script>

<style type="text/css" scoped>
  .top-header {
    margin-top: 28px;
  }
</style>
