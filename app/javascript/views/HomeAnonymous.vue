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

    <p>
      A new way to discover interesting classes and plan your course of study&mdash;check it out!
    </p>

    <div
      id="video-container"
      class="mb-4"
    />

    <div class="row vertical-align">
      <div class="col-sm-12 col-md-4">
        <span
          id="login-link-container"
          class="text-center w-100"
        >
          <a
            class="text-decoration-none"
            href="/users/sign_in"
          >
            Sign in with HarvardKey
          </a>
        </span>
      </div>

      <div class="col-sm-12 col-md-8">
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
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  #home-content {
    color: black;
    font-size: 20px;
    line-height: 24px;

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

  #login-link-container {
    display: inline-block;
    background: black;
    color: white;
    padding: 20px 30px;

    a {
      color: white;
    }
  }

  #video-container {
    border: 2px solid black;
    height: 360px;
    width: 640px;
  }

  .vertical-align {
    align-items: center;
  }
</style>
