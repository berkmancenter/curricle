<template>
  <div class="row mx-0">
    <div class="col-md-9">
      <h1 class="my-3"><b-link to="/explore">Explore</b-link></h1>

      <h3
        class="mb-5"
        style="font-weight: normal;">
        Use visualizations to explore the curriculum, follow unexpected connections, and discover new courses.
      </h3>

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

  h1 a.active {
    color: black;
  }
</style>
