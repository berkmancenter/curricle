# frozen_string_literal: true

# serve the Vue.js SPA
class LandingController < ApplicationController
  def index
    render layout: false
  end
end
