<template>
  <footer class="row fixed-bottom px-3">
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
  color: black;
  font-size: 14px;
  min-height: 5%;
  z-index: 9999;
}
</style>
