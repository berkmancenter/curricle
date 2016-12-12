require 'test_helper'

class PathControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get path_index_url
    assert_response :success
  end

end
