require "test_helper"

class ClubTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    club = Club.new(
      name: "Red Deer BMX Club",
      slug: "reddeerbmx",
      city: "Red Deer",
      country: "Canada"
    )
    assert club.valid?, "Club should be valid but has errors: #{club.errors.full_messages.join(', ')}"
  end

  test "should require name" do
    club = Club.new(slug: "test", city: "Test", country: "Canada")
    assert_not club.valid?
    assert_includes club.errors[:name], "can't be blank"
  end

  test "should require slug" do
    club = Club.new(name: "Test Club", city: "Test", country: "Canada")
    assert_not club.valid?
    assert_includes club.errors[:slug], "can't be blank"
  end

  test "should require city" do
    club = Club.new(name: "Test Club", slug: "test", country: "Canada")
    assert_not club.valid?
    assert_includes club.errors[:city], "can't be blank"
  end

  test "should require country" do
    club = Club.new(name: "Test Club", slug: "test", city: "Test")
    assert_not club.valid?
    assert_includes club.errors[:country], "can't be blank"
  end

  test "should have unique slug" do
    Club.create!(
      name: "First Club",
      slug: "firstclub",
      city: "Calgary",
      country: "Canada"
    )

    duplicate_club = Club.new(
      name: "Second Club",
      slug: "firstclub",
      city: "Edmonton",
      country: "Canada"
    )

    assert_not duplicate_club.valid?
    assert_includes duplicate_club.errors[:slug], "has already been taken"
  end

  test "should validate slug format" do
    club = Club.new(
      name: "Test Club",
      slug: "Test Club!", # Invalid: spaces and special chars
      city: "Test",
      country: "Canada"
    )
    assert_not club.valid?
    assert_includes club.errors[:slug], "only lowercase letters, numbers, and hyphens allowed"
  end

  test "should accept valid slug formats" do
    valid_slugs = [ "edmonton-bmx", "red-deer-bmx", "bmx2024", "club-123" ]

    valid_slugs.each do |slug|
      club = Club.new(
        name: "Test Club",
        slug: slug,
        city: "Test",
        country: "Canada"
      )
      assert club.valid?, "#{slug} should be valid but has errors: #{club.errors.full_messages.join(', ')}"
    end
  end

  test "should default active to true" do
    club = Club.new(
      name: "Test Club",
      slug: "testclub",
      city: "Test",
      country: "Canada"
    )
    assert club.active?
  end

  # Association tests
  test "should have many users" do
    club = Club.new
    assert_respond_to club, :users
  end

  test "should have one race" do
    club = Club.new
    assert_respond_to club, :race
  end

  test "should create race record after club creation" do
    club = Club.create!(
      name: "New BMX Club",
      slug: "newbmx",
      city: "Edmonton",
      country: "Canada"
    )

    assert_not_nil club.race
    assert_nil club.race.gate_counter
    assert_nil club.race.staging_counter
  end
end
