<template>
  <div class="row mx-0">
    <div class="col-md-9">
      <h1 class="my-3">Explore</h1>

      <b-card-group
        deck
        class="mb-5">
        <b-card title="Lecture Networks">
          <p class="card-text">Show connections between course instructors</p>
          <b-button
            href="#"
            variant="primary">
            Explore lecture networks
          </b-button>
        </b-card>
        <b-card title="Bar Comparison">
          <p class="card-text">Investigate class types and departments</p>
          <b-button
            href="#"
            variant="primary">
            Explore bar comparison
          </b-button>
        </b-card>
      </b-card-group>

      <h5 class="mb-3">Other Exploratory Micronarrative Links:</h5>

      <b-card-group columns>
        <b-card
          class="text-center"
          header="Header">
          <b-button href="#">
            Go somewhere
          </b-button>
        </b-card>

        <b-card
          class="text-center"
          header="Header">
          <b-button href="#">
            Go somewhere
          </b-button>
        </b-card>

        <b-card
          class="text-center"
          header="Header">
          <b-button href="#">
            Go somewhere
          </b-button>
        </b-card>

        <b-card
          class="text-center"
          header="Header">
          <b-button href="#">
            Go somewhere
          </b-button>
        </b-card>

        <b-card
          class="text-center"
          header="Header">
          <b-button href="#">
            Go somewhere
          </b-button>
        </b-card>

        <b-card
          class="text-center"
          header="Header">
          <b-button href="#">
            Go somewhere
          </b-button>
        </b-card>
      </b-card-group>
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
