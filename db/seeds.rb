# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create a super admin user if none exists
if User.where(role: User::SUPER_ADMIN).none?
  User.create!(
    email: "admin@bmxracetracker.com",
    password: "password123",
    name: "Super Admin",
    role: User::SUPER_ADMIN
  )
  puts "Created super admin user (admin@bmxracetracker.com / password123)"
  puts "This user can create clubs and manage the platform"
end

# Only create test data in development environment
if Rails.env.development?
  # Create a test club
  test_club = Club.find_or_create_by!(name: "Test BMX Club") do |club|
    club.slug = "test-bmx-club"
    club.city = "Toronto"
    club.country = "Canada"
  end
  puts "Created test club: #{test_club.name}"

  # Create a club admin user
  club_admin = User.find_or_create_by!(email: "clubadmin@bmxracetracker.com") do |user|
    user.password = "password123"
    user.name = "Club Admin"
    user.role = User::ADMIN
    user.club = test_club
  end
  puts "Created club admin user (clubadmin@bmxracetracker.com / password123)"

  # Create an operator user
  operator = User.find_or_create_by!(email: "operator@bmxracetracker.com") do |user|
    user.password = "password123"
    user.name = "Race Operator"
    user.role = User::OPERATOR
    user.club = test_club
  end
  puts "Created operator user (operator@bmxracetracker.com / password123)"

  puts "\nTest Users Summary:"
  puts "==================="
  puts "Super Admin: admin@bmxracetracker.com / password123 (can manage all clubs)"
  puts "Club Admin: clubadmin@bmxracetracker.com / password123 (can manage Test BMX Club)"
  puts "Operator: operator@bmxracetracker.com / password123 (can operate races for Test BMX Club)"
end