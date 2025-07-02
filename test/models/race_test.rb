require "test_helper"

class RaceTest < ActiveSupport::TestCase
  def setup
    @club = clubs(:airdrie)
  end

  test "should be valid with valid attributes" do
    race = Race.new(
      club: @club,
      gate_counter: 0,
      staging_counter: 1,
      registration_deadline: "09:30",
      race_start_time: "10:00"
    )
    assert race.valid?
  end

  test "should require club" do
    race = Race.new(
      gate_counter: 0,
      staging_counter: 1
    )
    assert_not race.valid?
    assert_includes race.errors[:club], "must exist"
  end

  test "should default counters to nil (race not started)" do
    race = Race.new(club: @club)
    assert_nil race.gate_counter
    assert_nil race.staging_counter
  end

  test "should allow nil counters when race not started" do
    race = Race.new(
      club: @club,
      gate_counter: nil,
      staging_counter: nil,
      registration_deadline: "09:30",
      race_start_time: "10:00"
    )
    assert race.valid?
  end

  test "should validate gate counter is not negative when present" do
    race = Race.new(
      club: @club,
      gate_counter: -1,
      staging_counter: 1
    )
    assert_not race.valid?
    assert_includes race.errors[:gate_counter], "must be greater than or equal to 0"
  end

  test "should validate staging counter is positive when present" do
    race = Race.new(
      club: @club,
      gate_counter: 0,
      staging_counter: 0
    )
    assert_not race.valid?
    assert_includes race.errors[:staging_counter], "must be greater than or equal to 1"
  end

  test "should validate staging counter is greater than gate counter when both present" do
    race = Race.new(
      club: @club,
      gate_counter: 5,
      staging_counter: 5
    )
    assert_not race.valid?
    assert_includes race.errors[:staging_counter], "must be greater than gate counter"

    race.staging_counter = 4
    assert_not race.valid?
    assert_includes race.errors[:staging_counter], "must be greater than gate counter"

    race.staging_counter = 6
    assert race.valid?
  end

  test "should validate both counters must be present or both nil" do
    # Gate present, staging nil
    race = Race.new(
      club: @club,
      gate_counter: 0,
      staging_counter: nil
    )
    assert_not race.valid?
    assert_includes race.errors[:base], "Both counters must be set when race is started"

    # Gate nil, staging present
    race = Race.new(
      club: @club,
      gate_counter: nil,
      staging_counter: 1
    )
    assert_not race.valid?
    assert_includes race.errors[:base], "Both counters must be set when race is started"
  end

  test "should belong to club" do
    race = Race.new
    assert_respond_to race, :club
  end

  test "should have started? method" do
    race = Race.new(club: @club)
    assert_not race.started?

    race.gate_counter = 0
    race.staging_counter = 1
    assert race.started?
  end

  test "should start race with counters" do
    # Use Calgary club which has no started race
    calgary = clubs(:calgary)
    race = calgary.race
    assert_not race.started? # Verify it's not started

    race.start_race!

    assert_equal 0, race.gate_counter
    assert_equal 1, race.staging_counter
    assert race.started?
  end

  test "should reset race counters" do
    # Use existing Airdrie race which has counters
    race = @club.race
    assert race.started? # Verify it's started

    race.reset_race!

    assert_nil race.gate_counter
    assert_nil race.staging_counter
    assert_not race.started?
  end
end
