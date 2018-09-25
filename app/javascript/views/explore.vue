<template>
  <div>
    <h1
      v-show="exploreRoot"
      class="my-3">
      <b-link to="/explore">Explore</b-link>
    </h1>

    <h3
      v-show="exploreRoot"
      class="mb-5"
      style="font-weight: normal;">
      Use visualizations to explore the curriculum, follow unexpected connections, and discover new courses.
    </h3>

    <router-view class="mt-5"/>
  </div>
</template>

<script>
export default {
  computed: {
    exploreRoot () {
      return this.$route.path === '/explore'
    }
  }
}
</script>

<style type="text/css">
  h1 a.active {
    color: black;
  }
</style>
