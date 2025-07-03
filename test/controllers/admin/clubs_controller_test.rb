require "test_helper"

class Admin::ClubsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin_calgary)
    sign_in @admin
  end
  test "should get index" do
    get admin_clubs_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_club_url
    assert_response :success
  end

  test "should post create" do
    assert_difference("Club.count") do
      post admin_clubs_url, params: { club: { name: "Edmonton BMX Racing", slug: "edmontonbmx", city: "Edmonton", country: "Canada" } }
    end
    assert_redirected_to admin_clubs_url
  end

  test "should get edit" do
    club = clubs(:airdrie)
    get edit_admin_club_url(club)
    assert_response :success
  end

  test "should patch update" do
    club = clubs(:airdrie)
    patch admin_club_url(club), params: { club: { name: "Airdrie BMX Association" } }
    assert_redirected_to admin_clubs_url
  end

  test "should destroy club" do
    # Create a club without users so it can be deleted
    club = Club.create!(name: "Red Deer BMX", slug: "reddeerbmx", city: "Red Deer", country: "Canada")
    assert_difference("Club.count", -1) do
      delete admin_club_url(club)
    end
    assert_redirected_to admin_clubs_url
  end
end
