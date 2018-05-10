<template>
  <div>
    <b-card-group
      deck
      class="mb-5">
      <b-card title="Lecture Networks">
        <p class="card-text">Show connections between course instructors</p>
        <b-button
          to="/explore/instructor"
          variant="primary">
          Explore lecture networks
        </b-button>
      </b-card>
      <b-card title="Bar Comparison">
        <p class="card-text">Investigate class types and departments</p>
        <b-button
          to="/explore/classes"
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
</template>
