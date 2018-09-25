<template>
  <div
    id="home-content"
    class="align-middle text-uppercase font-weight-bold">
    <img
      id="logo"
      class="mb-5"
      src="/images/logos/curricle-white-bg.svg">

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
    margin-left: 5%;
    margin-top: 20%;

    img#logo {
      display: block;
      height: 80px;
      width: auto;
    }

    strong {
      color: #000;
    }
  }
</style>
