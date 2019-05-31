<template>
  <div
    class="py-5"
  >
    <h3
      v-show="exploreRoot"
    >
      Explore:
    </h3>

    <div
      v-show="exploreRoot"
      class="row mb-5"
    >
      <div class="col-sm-12 col-md-5">
        Use visualizations to explore the curriculum, follow unexpected connections, and discover new courses.
      </div>
    </div>

    <router-view class="mt-5" />
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
