<template>
  <div
    class="row py-5"
  >
    <div
      class="col-md-8"
    >
      <h3>
        Frequently Asked Questions:
      </h3>

      <p>
        Get all of your burning questions about Curricle and how it works answered here. If your question isn’t here, reach out to us!
      </p>

      <h5>
        How is Curricle different from my.Harvard?
      </h5>

      <p>
        Glad that you asked! We offer
        <router-link to="/explore">
          a set of engaging visualizations</router-link>
        to help you navigate the Harvard course catalog and discover interesting classes.

        We have a planning tool that gives you
        <router-link to="/plan/week">
          a weekly calendar view</router-link>
        of your schedule,
        <router-link to="/plan/semester">
          semester-by-semester planning</router-link>
        with automatically imported transcript, and annotations to help you stay organized.

        We also make the course selection process streamlined by connecting courses directly to their Q evaluations and syllabus information and letting you send your courses to my.Harvard in one click.
      </p>

      <h5>
        Once I have added some courses to my schedule, am I done?
      </h5>

      <p>
        Nope! Make sure you click on the Export to my.Harvard button to send your schedule from this semester to my.Harvard catalog search page and finish the enrollment process there.
      </p>

      <h5>
        What gets shared when I click on Share Schedule?
      </h5>

      <p>
        When you click on Share Schedule, we generate for you a link for the Week view of your schedule with all the classes you have added there. This will include hidden classes and annotations you have already made.
      </p>

      <h5>
        The visualization doesn’t seem to work properly. Is it broken?
      </h5>

      <p>
        Try reloading the page if the visualization is behaving in an unexpected manner. If you suspect it’s a bug, let us know as we continue to improve Curricle in the many semesters to come.
      </p>

      <h5>
        This tool is pretty cool, but I do have some thoughts/feedback about it. How can I contribute?
      </h5>

      <p>
        We welcome suggestions and collaboration - whether you are a student or not! Get in touch with us at <a href="mailto:info@metalab.harvard.edu">info@metalab.harvard.edu</a> or use the giant Contact Us button below.
      </p>

      <div class="row mt-5 vertical-align">
        <div class="col-sm-12 col-md-4">
          <b-button
            class="w-100"
            href="mailto:info@metalab.harvard.edu"
            variant="dark"
          >
            Contact Us
          </b-button>
        </div>

        <div class="col-sm-12 col-md-8">
          Don’t see your question here? Is there a bug you’d like to report? Want to give us feedback? Write us, and we’ll get back to you as soon as we can!
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
h5 {
  font-size: 18px;
  font-style: italic;
  font-weight: bold;
  margin-bottom: 0;
  margin-top: 30px;
}

.vertical-align {
  align-items: center;
}
</style>
