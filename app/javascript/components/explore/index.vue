<template>
  <div>
    <b-card-group
      deck
      class="mb-5">
      <b-card
        img-src="/images/explore/departments.png"
        img-top
        title="Departments &amp; Types">
        <p class="card-text">
          Explore courses by selecting components (class formats) and departments (subjects and courses of study).
        </p>

        <div slot="footer">
          <b-button
            to="/explore/classes"
            variant="primary">
            View
          </b-button>
        </div>
      </b-card>

      <b-card
        img-src="/images/explore/instructors.png"
        img-top
        title="Instructors">
        <p class="card-text">
          Discover faculty networks of teaching and learning. Select an instructor to see faculty with whom they've co-taught, connecting through courses to departments.
        </p>

        <div slot="footer">
          <b-button
            to="/explore/instructor"
            variant="primary">
            View
          </b-button>
        </div>
      </b-card>

      <b-card
        img-src="/images/explore/keywords.png"
        img-top
        title="Keywords">
        <p class="card-text">
          Visualize the appearance of terms across the curriculum.
        </p>

        <div slot="footer">
          <b-button
            disabled
            variant="secondary">
            Coming Soon
          </b-button>
        </div>
      </b-card>

      <b-card
        img-src="/images/explore/courses.png"
        img-top
        title="All Courses">
        <p class="card-text">
          Get an overview of the universe of courses offered at Harvard, and explore departments and programs to browse their offerings.
        </p>

        <div slot="footer">
          <b-button
            to="/explore/universe"
            variant="primary">
            View
          </b-button>
        </div>
      </b-card>
    </b-card-group>
  </div>
</template>

<style scoped>
h4.card-title {
  font-size:1.4rem;
}
</style>
