# db/seeds.rb

# Create test user
user = User.find_or_create_by!(email: "test@example.com") do |user|
  user.password = "password123"
end

# Create the Soork
soork = Soork.create!(
  title: "The Dusty Library",
  description: "A mysterious adventure in an abandoned library",
  user: user
)

# Create rooms
entrance = Room.create!(
  soork: soork,
  name: "Library Entrance",
  description: "You stand in a dimly lit entrance. Dust motes dance in the air. Towering bookshelves loom to the north.",
  start_room: true,
  x: 0,
  y: 0
)

main_hall = Room.create!(
  soork: soork,
  name: "Main Reading Hall",
  description: "A grand reading hall stretches before you. Ancient tables and chairs are scattered about. A narrow corridor leads east.",
  x: 0,
  y: 1
)

study = Room.create!(
  soork: soork,
  name: "Private Study",
  description: "A cozy study with a mahogany desk. A curious lockbox sits on the desk.",
  x: 1,
  y: 1
)

# Connect rooms
RoomConnection.create!(source_room: entrance, target_room: main_hall, direction: 'north')
RoomConnection.create!(source_room: main_hall, target_room: entrance, direction: 'south')
RoomConnection.create!(source_room: main_hall, target_room: study, direction: 'east')
RoomConnection.create!(source_room: study, target_room: main_hall, direction: 'west')

# Create items
Item.create!(
  room: entrance,
  name: "Brass Key",
  description: "An ornate brass key with intricate engravings.",
  examine_text: "The key looks very old, but well-crafted. Strange symbols are carved into its surface.",
  properties: { unlocks: "antique lockbox" }
)

Item.create!(
  room: study,
  name: "Ancient Lockbox",
  description: "A mysterious wooden box with a brass lock.",
  examine_text: "The lockbox is made of dark wood, with ornate brass fittings. It seems to be locked.",
  is_pickable: false,
  properties: { requires_key: true }
)

puts "Created Soork 'The Dusty Library' with ID: #{soork.id}"