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

    <p>
      A transformative tool for course discovery, selection, and planning.
    </p>

    <div class="mb-4">
      <iframe
        src="https://player.vimeo.com/video/354848830"
        width="640"
        height="360"
        frameborder="0"
        allow="autoplay; fullscreen"
        allowfullscreen
      />
    </div>

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
          CURRICLE is ready for Spring 2020!
        </strong>

        <br>

        Check out the latest
        <a
          href="https://curricle.wpengine.com/"
          target="_blank"
        >
          news</a>
        on updates and new features.
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

  .vertical-align {
    align-items: center;
  }
</style>
