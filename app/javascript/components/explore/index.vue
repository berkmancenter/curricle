<template>
  <div>
    <b-card-group
      deck
      class="mb-5">
      <router-link
        to="/explore/classes"
        variant="primary">
      <b-card
        img-src="/images/explore/departments.png"
        img-top
        title="Learning Modes">       
        <p class="card-text">
          Explore courses by selecting class learning modes and departments.
        </p>
      </b-card>
      </router-link>
      <router-link
        to="/explore/instructor"
        variant="primary">
      <b-card
        img-src="/images/explore/instructors.png"
        img-top
        title="Instructor Networks">
        <p class="card-text">
          Select an instructor to discover faculty networks by course and department.
        </p>
      </b-card>
      </router-link>
      <router-link
        to="/explore/keywords"
        variant="primary">
      <b-card
        img-src="/images/explore/keywords.png"
        img-top
        title="Truth vs. Lies">
        <p class="card-text">
          Visualize descriptive terms across the curriculum through keyword comparisons.
        </p>
      </b-card>
      </router-link>
      <router-link
        to="/explore/universe"
        variant="primary">
      <b-card
        img-src="/images/explore/courses.png"
        img-top
        title="Course Universe">
        <p class="card-text">
          Explore all of Harvard's departments and programs to browse their offerings.
        </p>
      </b-card>
      </router-link>
    </b-card-group>
  </div>
</template>

<style scoped>
h4.card-title {
  font-size:1.4rem;
}
</style>
