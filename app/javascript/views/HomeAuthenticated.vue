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
        src="/images/logos/curricle-white-bg.svg"
      >
    </p>

    <p class="mb-5">
      <router-link
        class="text-decoration-none text-uppercase"
        to="/explore"
      >
        <strong>explore</strong>
      </router-link>
      and
      <router-link
        class="text-decoration-none text-uppercase"
        to="/search"
      >
        <strong>search</strong>
      </router-link>
      the curriculum for interesting classes

      <br>

      <router-link
        class="text-decoration-none text-uppercase"
        to="/plan"
      >
        <strong>plan</strong>
      </router-link>
      your semester with confidence

      <br>

      <strong class="text-uppercase">
        EXPORT
      </strong>
      your schedule to
      <a
        class="text-decoration-none font-italic"
        href="https://portal.my.harvard.edu"
      >
        my.Harvard</a>
      to enroll
    </p>

    <p>
      <strong class="font-italic">
        CURRICLE Beta 2 is preparing for its Fall 2019 roll-out!
      </strong>

      <br>

      Check out our
      <a
        href="https://curricle.wpengine.com/"
        target="_blank"
      >
        news</a>
      for the latest updates and new features.
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
