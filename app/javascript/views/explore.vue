<template>
  <div>
    <h1 class="my-3"><b-link to="/explore">Explore</b-link></h1>

    <h3
      class="mb-5"
      style="font-weight: normal;">
      Use visualizations to explore the curriculum, follow unexpected connections, and discover new courses.
    </h3>

    <router-view/>
  </div>
</template>

<style type="text/css">
  h1 a.active {
    color: black;
  }
</style>
