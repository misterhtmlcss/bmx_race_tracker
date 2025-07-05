require "test_helper"

class ClubRaceTrackerFlowTest < ActionDispatch::IntegrationTest
  test "visiting club-specific race tracker page" do
    club = clubs(:airdrie)
    
    # Visit the club-specific page
    get club_race_url(slug: club.slug)
    assert_response :success
    
    # Verify we're on the right page
    assert_select "h1", "#{club.name} Race Tracker"
    
    # Verify the race tracker interface is present
    assert_select ".counter-section", count: 2
    assert_select ".counter-display", count: 2
    assert_select ".counter-btn", count: 4
    
    # Verify initial counter values
    assert_select ".at-gate .counter-display", "0"
    assert_select ".in-staging .counter-display", "1"
  end

  test "invalid club slug redirects to home" do
    # Try to visit a non-existent club page
    get "/fakeclubname"
    assert_redirected_to root_url
    follow_redirect!
    
    # Verify we're on the home page
    assert_select "h1", "BMX Race Tracker"
  end

  test "club page maintains same interface as home page" do
    club = clubs(:calgary)
    
    # Get home page structure
    get root_url
    home_buttons = css_select(".counter-btn").size
    
    # Get club page structure
    get club_race_url(slug: club.slug)
    club_buttons = css_select(".counter-btn").size
    
    # Both should have the same number of controls
    assert_equal home_buttons, club_buttons
  end

  test "authentication links work on club pages" do
    club = clubs(:airdrie)
    admin = users(:admin_calgary)
    
    # Visit as anonymous user
    get club_race_url(slug: club.slug)
    assert_select ".auth-btn.login-btn"
    
    # Sign in and revisit
    sign_in admin
    get club_race_url(slug: club.slug)
    assert_select ".auth-btn.admin-btn"
    assert_select ".auth-btn.logout-btn"
  end
end