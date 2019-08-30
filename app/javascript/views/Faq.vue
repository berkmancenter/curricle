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
        Get all of your burning questions about Curricle answered here. If your question isn’t addressed,
        feel free reach out to us at <a href="mailto:info@metalab.harvard.edu">info@metalab.harvard.edu</a>.
      </p>

      <h5>
        How is Curricle different from my.harvard?
      </h5>

      <p>
        Glad that you asked. While my.harvard is the centralized information
        system used by Harvard students to manage course registration and by
        faculty, staff, and administrators to oversee enrollments and advising,
        Curricle is designed with the curriculum firmly in mind. It is built to
        prompt intellectual curiosity and adventure, and to help with planning.
        To that end, it offers
        <router-link to="/explore">
          a set of engaging visualizations</router-link>
        to help you navigate
        the Harvard course catalog and discover interesting classes. It also provides
        a planning tool that gives you
        <router-link to="/plan/week">
          a weekly calendar view</router-link>
        of your schedule,
        <router-link to="/plan/semester">
          semester-by-semester planning</router-link>
        with an automatically imported transcript,
        and annotations to help you stay organized. Curricle further streamlines
        the course selection process by connecting courses directly to their syllabi
        and to Q evaluations while letting you export your courses to my.harvard with a single click.
      </p>

      <h5>
        Are the courses I'm seeing on Curricle also on my.harvard?
      </h5>

      <p>
        While Curricle course data are updated frequently, my.harvard
        is the home of Harvard's authoritative course database. Be sure
        to check there to get changes or additions to the latest course listings.
      </p>

      <h5>
        How should I make use of my "Schedule" in Curricle?
      </h5>

      <p>
        Creatively! Your "Schedule" is where you can add courses that
        potentially interest you. You can sift through these courses,
        view them in a weekly plan, annotate them, and share them with
        friends and advisers. Your schedule is yours alone. Unless you
        share it with others, it's your place to collect, curate, and
        play with course plans and ideas.
      </p>

      <h5>
        Once I have added some courses to my schedule, am I done?
      </h5>

      <p>
        Not quite. Make sure you click on the Export to my.harvard button
        to send your schedule over to my.harvard where you can complete
        the enrollment process. Curricle is a course discovery, exploration,
        and planning tool, not a registration platform.
      </p>

      <h5>
        What gets shared when I click on Share Schedule?
      </h5>

      <p>
        When you click on Share Schedule, Curricle generates a link to
        the Week View of your schedule with all the classes you have
        added, even if they are hidden.
      </p>

      <h5>
        Are the annotations I add to courses private?
      </h5>

      <p>
        Your personal notes for courses &mdash; whether they are added
        to your schedule or not &mdash; will remain private and visible
        only to you.
      </p>

      <h5>
        A visualization doesn’t seem to work properly. Is it broken?
      </h5>

      <p>
        Try refreshing the page if one of Curricle’s EXPLORE
        visualizations is behaving in an unexpected manner. If you
        suspect it’s a bug, please let us know. Our goal is to keep
        improving the tool.
      </p>

      <h5>
        Can the advanced search filter classes by times of the day or days of the week?
      </h5>

      <p>
        Search by times when classes meet is a feature that is currently
        in the works. We will update the platform as soon as we have that
        feature tested, so check back soon!
      </p>

      <h5>
        What is Curricle Lens?
      </h5>

      <p>
        Curricle Lens is a research platform where you can dig into
        data-driven stories about the history of the Harvard curriculum.
        Leveraging the strength of visualized data and interactive
        storytelling, Curricle Lens can take you on a guided tour of how
        the Department of African and African-American Studies has grown
        and transformed, how the curricular tension between humanities and
        sciences shifted over time, how prominent luminaries like Gertrude
        Stein and T. S. Eliot navigated the course catalog in their
        collegiate days, and many more stories like these. Tune in for the
        platform launch on October 1, 2019!
      </p>

      <h5>
        This tool is pretty cool, but I do have some thoughts/feedback about it. How can I contribute?
      </h5>

      <p>
        We welcome suggestions and collaborators &mdash; whether you're
        a student, an instructor, or an administrator. Please get in touch
        with us at <a href="mailto:info@metalab.harvard.edu">info@metalab.harvard.edu</a>
        or click on the Contact Us button below.
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
          Is there a bug you’d like to report? Want to provide some feedback? Write us and we’ll get back to you as soon as we can.
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
