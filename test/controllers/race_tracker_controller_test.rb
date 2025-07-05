require "test_helper"

class RaceTrackerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
    assert_select "h1", "BMX Race Tracker"
  end

  test "index displays default counter values" do
    get root_url
    assert_response :success
    # Check that the counter displays show the default values
    assert_select ".at-gate .counter-display", "0"
    assert_select ".in-staging .counter-display", "1"
  end

  test "should get show with valid club slug" do
    club = clubs(:airdrie)
    get club_race_url(slug: club.slug)
    assert_response :success
    # Verify the club name is displayed
    assert_select "h1", "#{club.name} Race Tracker"
  end

  test "show displays default counter values" do
    club = clubs(:airdrie)
    get club_race_url(slug: club.slug)
    assert_response :success
    # Check that the counter displays show the default values
    assert_select ".at-gate .counter-display", "0"
    assert_select ".in-staging .counter-display", "1"
  end

  test "should redirect to root with invalid club slug" do
    get club_race_url(slug: "nonexistent")
    assert_redirected_to root_url
    assert_equal "Club not found", flash[:alert]
  end

  test "should handle slug with hyphens" do
    club = clubs(:calgary)
    get club_race_url(slug: club.slug)
    assert_response :success
    assert_select "h1", "#{club.name} Race Tracker"
  end

  test "should display club name on show page" do
    club = clubs(:airdrie)
    get club_race_url(slug: club.slug)
    assert_response :success
    assert_select "h1", text: /#{club.name}/
  end

  test "should handle invalid URL patterns" do
    # Test uppercase - should not match route
    get "/UPPERCASE"
    assert_response :not_found
  rescue ActionController::RoutingError
    # This is expected behavior - the route constraint blocks uppercase
    assert true
  end

  test "should handle inactive clubs" do
    club = clubs(:airdrie)
    club.update!(active: false)
    get club_race_url(slug: club.slug)
    assert_response :success
    # Inactive clubs still show the page
    assert_select "h1", "#{club.name} Race Tracker"
  end

  test "root path renders race tracker interface" do
    get root_url
    assert_response :success
    assert_select ".counter-section.at-gate"
    assert_select ".counter-section.in-staging"
    assert_select ".counter-btn.increment", count: 2
    assert_select ".counter-btn.decrement", count: 2
  end

  test "club-specific page renders race tracker interface" do
    club = clubs(:airdrie)
    get club_race_url(slug: club.slug)
    assert_response :success
    assert_select ".counter-section.at-gate"
    assert_select ".counter-section.in-staging"
    assert_select ".counter-btn.increment", count: 2
    assert_select ".counter-btn.decrement", count: 2
  end

  test "authentication links shown when not signed in" do
    get root_url
    assert_select ".auth-btn.login-btn", "Login"
    assert_select ".auth-btn.logout-btn", false
  end

  test "admin and logout links shown when signed in as admin" do
    admin = users(:admin_calgary)
    sign_in admin
    get root_url
    assert_select ".auth-btn.admin-btn", "Admin"
    assert_select ".auth-btn.logout-btn", "Logout"
    assert_select ".auth-btn.login-btn", false
  end

  test "only logout link shown when signed in as regular user" do
    user = users(:operator_airdrie)
    sign_in user
    get root_url
    assert_select ".auth-btn.logout-btn", "Logout"
    assert_select ".auth-btn.admin-btn", false
    assert_select ".auth-btn.login-btn", false
  end
end