<template>
  <div>
    <div class="row">
      <div class="col-md-12">
        <b-jumbotron
          header-level="4"
          class="text-center">
          <template slot="header">
            The Catalog will help you <strong>explore</strong> Harvard's course history,
            <strong>plan</strong> for your semester schedule, and <strong>search</strong> by keywords.
          </template>
        </b-jumbotron>
      </div>
    </div>

    <div class="row">
      <div class="col-md-4">
        <h5>Search</h5>

        <router-link to="/search">
          <img
            alt="Search"
            class="thumbnail"
            src="/images/home/search.png">
        </router-link>
      </div>

      <div class="col-md-4">
        <h5>Explore</h5>

        <router-link to="/explore">
          <img
            alt="Explore"
            class="thumbnail"
            src="/images/home/explore.png">
        </router-link>
      </div>

      <div class="col-md-4">
        <h5>Plan</h5>

        <router-link to="/plan">
          <img
            alt="Plan"
            class="thumbnail"
            src="/images/home/plan.png">
        </router-link>
      </div>
    </div>
  </div>
</template>

<style scoped>
  img.thumbnail {
    border: 2px solid #000;
    padding: 3px;
    width: 90%;
  }
</style>
