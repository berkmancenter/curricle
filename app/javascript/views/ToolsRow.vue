<template>
  <div class="row mt-4">
    <div class="col-sm-12 col-md-4 pt-1">
      <b-button
        class="w-100"
        variant="dark"
        target="_blank"
        :href="link"
      >
        {{ buttonLabel }}
      </b-button>
    </div>

    <div class="col-sm-12 col-md-8">
      {{ description }}
    </div>
  </div>
</template>

<script>
export default {
  props: {
    buttonLabel: {
      type: String,
      required: true
    },
    description: {
      type: String,
      required: true
    },
    link: {
      type: String,
      required: true
    }
  }
}
</script>
