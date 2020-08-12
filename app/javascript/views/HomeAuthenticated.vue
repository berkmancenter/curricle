<template>
  <div
    id="home-content"
    class="pt-5"
  >
    <p>
      Welcome to
    </p>

    <p>
      <img
        id="logo"
        src="/images/logos/curricle_white_bg_no_beta.svg"
      >
    </p>

    <p class="mb-5">
      <router-link
        class="text-decoration-none text-uppercase"
        to="/explore"
      >
        <strong>explore</strong>
      </router-link>
      the curriculum and
      <router-link
        class="text-decoration-none text-uppercase"
        to="/search"
      >
        <strong>search</strong>
      </router-link>
      for courses

      <br>

      <router-link
        class="text-decoration-none text-uppercase"
        to="/plan"
      >
        <strong>plan</strong>
      </router-link>
      out your semester

      <br>

      <strong class="text-uppercase">
        ENROLL
      </strong>
      in classes at
      <a
        class="text-decoration-none font-italic"
        href="https://portal.my.harvard.edu"
      >
        my.harvard</a>
      by exporting your schedule
    </p>

    <p>
      Check out the latest
      <a
        href="https://curricle.wpengine.com/"
        target="_blank"
      >
        news</a>
      on updates and new features.
    </p>
  </div>
</template>

<style lang="scss" scoped>
  #home-content {
    color: black;
    font-size: 24px;
    line-height: 28px;
    margin-top: 10%;

    img#logo {
      display: block;
      height: 80px;
      max-width: 100%;
      width: auto;
    }

    a {
      color: black;
      text-decoration: underline;
    }
  }
</style>
