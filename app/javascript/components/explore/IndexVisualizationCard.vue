<template>
  <div class="row mb-5">
    <div class="col-sm-12 col-md-5">
      <img
        class="img-fluid rounded"
        :src="image"
      >
    </div>

    <div class="col-sm-12 col-md-4">
      <p>
        <strong class="text-uppercase">
          {{ title }}
        </strong>
      </p>

      <p>{{ text }}</p>

      <b-button
        :to="link"
        variant="dark"
      >
        View
      </b-button>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    image: {
      type: String,
      required: true
    },
    link: {
      type: String,
      required: true
    },
    text: {
      type: String,
      required: true
    },
    title: {
      type: String,
      required: true
    }
  }
}
</script>

<style lang="scss" scoped>
  img.rounded {
    border: 1px solid lightgray;
  }
</style>
