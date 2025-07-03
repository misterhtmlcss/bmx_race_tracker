require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin_calgary)
    sign_in @admin
  end
  test "should get index" do
    get admin_users_url
    assert_response :success
  end
end
