# db/seeds.rb
# Create test user
user = User.find_or_create_by!(email: "test@example.com") do |user|
  user.password = "password123"
end

# Create the CLI Soork
soork = Cli::Soork.create!(
  title: "The Dusty Library",
  description: "A mysterious adventure in an abandoned library",
  user: user
)

# Create rooms
entrance = Cli::Room.create!(
  soork: soork,
  name: "Library Entrance",
  description: "You stand in a dimly lit entrance. Dust motes dance in the air. Towering bookshelves loom to the north.",
  start_room: true,
  x: 0,
  y: 0
)

main_hall = Cli::Room.create!(
  soork: soork,
  name: "Main Reading Hall",
  description: "A grand reading hall stretches before you. Ancient tables and chairs are scattered about. A narrow corridor leads east.",
  x: 0,
  y: 1
)

study = Cli::Room.create!(
  soork: soork,
  name: "Private Study",
  description: "A cozy study with a mahogany desk. A curious lockbox sits on the desk.",
  x: 1,
  y: 1
)

# Connect rooms
Cli::RoomConnection.create!(source_room: entrance, target_room: main_hall, direction: 'north')
Cli::RoomConnection.create!(source_room: main_hall, target_room: entrance, direction: 'south')
Cli::RoomConnection.create!(source_room: main_hall, target_room: study, direction: 'east')
Cli::RoomConnection.create!(source_room: study, target_room: main_hall, direction: 'west')

# Create items
Cli::Item.create!(
  room: entrance,
  name: "Brass Key",
  description: "An ornate brass key with intricate engravings.",
  examine_text: "The key looks very old, but well-crafted. Strange symbols are carved into its surface.",
  properties: { unlocks: "Ancient Lockbox" }
)

Cli::Item.create!(
  room: study,
  name: "Ancient Lockbox",
  description: "A mysterious wooden box with a brass lock.",
  examine_text: "The lockbox is made of dark wood, with ornate brass fittings. It seems to be locked.",
  is_pickable: false,
  properties: { requires_key: true }
)

puts "Created CLI Soork 'The Dusty Library' with ID: #{soork.id}"

puts "Creating Web test data..."

web_soork = Web::Soork.create!(
  title: "The Digital Library",
  description: "A futuristic adventure in a virtual library",
  user: user,
  state: 'published'
)

puts "Created Web Soork 'The Digital Library' with ID: #{web_soork.id}"

entrance = Web::Area.create!(
  soork: web_soork,
  name: "Digital Entrance",
  description: "You stand before a shimmering portal into the digital realm. Data streams flow around you like waterfalls.",
  start_area: true
)

main_hall = Web::Area.create!(
  soork: web_soork,
  name: "Central Data Hub",
  description: "A vast chamber filled with floating data crystals. Information pulses through fiber optic pathways.", 
)

archive_room = Web::Area.create!(
  soork: web_soork,
  name: "Archive Vault",
  description: "Ancient servers hum quietly. A single terminal glows in the center"
)

Web::AreaConnection.create!(source_area: entrance, target_area: main_hall, direction: 'north')
Web::AreaConnection.create!(source_area: main_hall, target_area: entrance, direction: 'south')
Web::AreaConnection.create!(source_area: main_hall, target_area: archive_room, direction: 'east')
Web::AreaConnection.create!(source_area: archive_room, target_area: main_hall, direction: 'west')

Web::Item.create!(
  soork: web_soork,
  area: entrance,
  name: "Data Crystal",
  description: "A glowing crystal containing encrypted data.",
  examine_text: "The crystal pulses with blue light. Ancient code scrolls across its surface.",
)

Web::Item.create!(
  soork: web_soork,
  area: archive_room,
  name: "Access Terminal",
  description: "A sleek terminal interface",
  examine_text: "The screen displays: 'Please insert data crystal to continue...'",
  is_pickable: false,
)

game_session = Web::GameSession.create!(
  user: user,
  soork: web_soork,
  current_area: entrance
)

puts "Created Web::Soork '#{web_soork.title}' with ID: #{web_soork.id}"
puts "Created Web::GameSession with ID: #{game_session.id}"
