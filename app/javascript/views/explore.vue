<template>
  <div class="row mx-0">
    <div class="col-md-9">
      <h1 class="my-3">Explore</h1>

      <router-view/>
    </div>

    <div class="col-md-3 top-header">
      <the-sidebar />
    </div>
  </div>
</template>

<script>
import TheSidebar from 'components/TheSidebar'

export default {
  components: {
    TheSidebar
  }
}
</script>

<style type="text/css">
  .top-header {
    margin-top: 28px;
  }
</style>
