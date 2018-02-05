<template>
  <div class="row mx-0">
    <div class="col-md-9">
      <hr>
      <b-jumbotron
        header="Explore"
        lead="View Template">
        <p>Paragraph</p>

        <b-btn
          variant="primary"
          href="#">
          Button
        </b-btn>
      </b-jumbotron>
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
