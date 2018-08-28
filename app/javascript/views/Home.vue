<template>
  <div
    id="home-content"
    class="align-middle text-uppercase h-100 font-weight-bold">
    <img
      class="mb-5"
      style="width: 100px; height: 100px;"
      src="/images/logos/logo_tc.png">

    <strong>Curricle</strong> will help you<br>
    <router-link
      to="/explore">
      <strong>explore</strong>
    </router-link>
    the Harvard curriculum, past and present,<br>
    <router-link
      to="/plan">
      <strong>plan</strong>
    </router-link>
    your semester schedule,<br>
    and
    <router-link
      to="/search">
      <strong>search</strong>
    </router-link>
    by keywords.
  </div>
</template>

<style lang="scss" scoped>
  #home-content {
    color: #bbb;
    font-size: 30px;
    line-height: 34px;
    padding: 300px 100px 0 100px;

    img {
      display: block;
    }

    strong {
      color: #000;
    }
  }
</style>
