require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @club = clubs(:airdrie)
  end

  test "should be valid with valid attributes" do
    user = User.new(
      email: "operator@example.com",
      password: "password123",
      name: "John Operator",
      role: 0, # operator
      club: @club
    )
    assert user.valid?
  end

  test "should require email" do
    user = User.new(
      password: "password123",
      name: "John Operator",
      role: 0,
      club: @club
    )
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "should require valid email format" do
    user = User.new(
      email: "invalid-email",
      password: "password123",
      name: "John Operator",
      role: 0,
      club: @club
    )
    assert_not user.valid?
  end

  test "should require unique email" do
    User.create!(
      email: "test@example.com",
      password: "password123",
      name: "First User",
      role: 0,
      club: @club
    )

    duplicate_user = User.new(
      email: "test@example.com",
      password: "password123",
      name: "Second User",
      role: 0,
      club: @club
    )

    assert_not duplicate_user.valid?
  end

  test "should require password" do
    user = User.new(
      email: "test@example.com",
      name: "John Operator",
      role: 0,
      club: @club
    )
    assert_not user.valid?
  end

  test "should require name" do
    user = User.new(
      email: "test@example.com",
      password: "password123",
      role: 0,
      club: @club
    )
    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "should require role" do
    user = User.new(
      email: "test@example.com",
      password: "password123",
      name: "John Operator",
      club: @club
    )
    assert_not user.valid?
    assert_includes user.errors[:role], "can't be blank"
  end

  test "operator and admin should require club" do
    # Operator without club
    operator = User.new(
      email: "operator@example.com",
      password: "password123",
      name: "John Operator",
      role: 0
    )
    assert_not operator.valid?
    assert_includes operator.errors[:club], "must exist"

    # Admin without club
    admin = User.new(
      email: "admin@example.com",
      password: "password123",
      name: "Jane Admin",
      role: 1
    )
    assert_not admin.valid?
    assert_includes admin.errors[:club], "must exist"
  end

  test "super_admin should not require club" do
    super_admin = User.new(
      email: "superadmin@example.com",
      password: "password123",
      name: "Super Admin",
      role: 2,
      club: nil
    )
    assert super_admin.valid?
  end

  test "should define role constants" do
    assert_equal 0, User::OPERATOR
    assert_equal 1, User::ADMIN
    assert_equal 2, User::SUPER_ADMIN
  end

  test "should have role helper methods" do
    operator = User.new(role: 0)
    assert operator.operator?
    assert_not operator.admin?
    assert_not operator.super_admin?

    admin = User.new(role: 1)
    assert_not admin.operator?
    assert admin.admin?
    assert_not admin.super_admin?

    super_admin = User.new(role: 2)
    assert_not super_admin.operator?
    assert_not super_admin.admin?
    assert super_admin.super_admin?
  end

  test "should have role name method" do
    operator = User.new(role: 0)
    assert_equal "operator", operator.role_name

    admin = User.new(role: 1)
    assert_equal "admin", admin.role_name

    super_admin = User.new(role: 2)
    assert_equal "super_admin", super_admin.role_name
  end

  test "should belong to club" do
    user = User.new
    assert_respond_to user, :club
  end
end
