# frozen_string_literal: true

# serve the Vue.js SPA
class LandingController < ApplicationController
  before_action :authenticate_user!

  def index
    render layout: false
  end
end
