<template>
  <footer class="row w-100 mx-0">
    <div class="col-md-6 d-flex align-self-center">
      <the-data-last-updated-indicator />
    </div>

    <div class="col-md-6 d-flex align-self-center justify-content-md-end">
      <the-feedback-link />
    </div>
  </footer>
</template>

<script>
import TheDataLastUpdatedIndicator from 'components/TheDataLastUpdatedIndicator'
import TheFeedbackLink from 'components/TheFeedbackLink'

export default {
  components: {
    TheDataLastUpdatedIndicator,
    TheFeedbackLink
  }
}
</script>

<style lang="scss" scoped>
footer {
  background-color: white;
  border-top: 1px solid #f5f5f5;
  bottom: 0;
  color: black;
  font-size: 14px;
  height: 5%;
  position: absolute;
  z-index: 9999;
}
</style>
