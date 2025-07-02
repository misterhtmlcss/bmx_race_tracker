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