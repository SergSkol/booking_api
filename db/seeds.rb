# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create a test user
User.create!(
  name: 'Admin',
  email: 'exapmle@exapmle.com',
  password: '123456',
  role: 'admin'
)

# Create a test Item
Item.create!(
  name: 'Luxurious Villa',
  description: 'The first housing unit on our list',
  photo: 'https://images.pexels.com/photos/258154/pexels-photo-258154.jpeg',
  location: 'Las Vegas',
  price: 1788.24
)

Item.create!(
  name: 'Big Living Room',
  description: 'The second housing unit on our list',
  photo: 'https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg',
  location: 'New York',
  price: 995.95
)

Item.create!(
  name: 'House in the country side',
  description: 'The third housing unit on our list',
  photo: 'https://images.pexels.com/photos/2510067/pexels-photo-2510067.jpeg',
  location: 'Prague',
  price: 567.89
)

# Create a test reservation
Reservation.create!(
  start_date: Time.now,
  end_date: Time.now + 5 * 24 * 3600,
  item: Item.first,
  user: User.first
)

# Doorkeeper record in oauth_application with uid/client_id and client_secret
doorkeeper = Doorkeeper::Application.find_or_create_by(name: "React") do |app|
  app.redirect_uri = ""
  app.save!
end

LIGHTBLUE = "\e[1;34m"
GREEN = "\e[1;32m"
RESET = "\e[0m"

puts "#{LIGHTBLUE}Doorkeeper Application has been created. Please use these values in the front-end#{RESET}"
puts "client_id is #{GREEN}#{doorkeeper.uid}#{RESET}"
puts "client_secret is #{GREEN}#{doorkeeper.read_attribute(:secret)}#{RESET}"
