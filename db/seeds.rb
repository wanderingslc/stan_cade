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

# Story 1: The Digital Library (Updated)
web_soork = Web::Soork.create!(
  title: "The Digital Library",
  description: "A futuristic adventure in a virtual library",
  user: user,
  state: 'published',
  published: true
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

# Items for Digital Library
data_crystal = Web::Item.create!(
  soork: web_soork,
  area: entrance,
  name: "Data Crystal",
  description: "A glowing crystal containing encrypted data.",
  examine_text: "The crystal pulses with blue light. Ancient code scrolls across its surface.",
)

access_terminal = Web::Item.create!(
  soork: web_soork,
  area: archive_room,
  name: "Access Terminal",
  description: "A sleek terminal interface",
  examine_text: "The screen displays: 'Please insert data crystal to continue...'",
  is_pickable: false,
)

# Interaction: Use data crystal on terminal
Web::Interaction.create!(
  area: archive_room,
  item: data_crystal,
  target_name: "access terminal",
  success_message: "The terminal accepts the crystal! The screen lights up revealing: 'Archive unlocked. Welcome, researcher.'",
  effects: { "unlocks_archive" => true },
  consumes_item: false
)

# Story 2: The Abandoned Mine (New story with both mechanics)
mine_soork = Web::Soork.create!(
  title: "The Abandoned Mine",
  description: "Explore the depths of an old mining operation",
  user: user,
  state: 'published',
  published: true
)
puts "Created Web Soork 'The Abandoned Mine' with ID: #{mine_soork.id}"

# Areas
mine_entrance = Web::Area.create!(
  soork: mine_soork,
  name: "Mine Entrance",
  description: "The entrance to an old mine shaft. Rusted equipment lies scattered about.",
  start_area: true
)

storage_shed = Web::Area.create!(
  soork: mine_soork,
  name: "Storage Shed",
  description: "A small wooden shed filled with mining supplies and old equipment."
)

dark_tunnel = Web::Area.create!(
  soork: mine_soork,
  name: "Dark Tunnel",
  description: "A pitch-black tunnel stretches ahead. You can barely see your hand in front of your face."
  )

mining_chamber = Web::Area.create!(
  soork: mine_soork,
  name: "Mining Chamber", 
  description: "A large chamber carved from the rock. Old mining equipment sits abandoned."
)

# Connections
Web::AreaConnection.create!(source_area: mine_entrance, target_area: storage_shed, direction: 'west')
Web::AreaConnection.create!(source_area: storage_shed, target_area: mine_entrance, direction: 'east')
Web::AreaConnection.create!(source_area: mine_entrance, target_area: dark_tunnel, direction: 'north')
Web::AreaConnection.create!(source_area: dark_tunnel, target_area: mine_entrance, direction: 'south')
Web::AreaConnection.create!(source_area: dark_tunnel, target_area: mining_chamber, direction: 'north')
Web::AreaConnection.create!(source_area: mining_chamber, target_area: dark_tunnel, direction: 'south')

# Items for Abandoned Mine
flashlight = Web::Item.create!(
  soork: mine_soork,
  area: storage_shed,
  name: "Flashlight",
  description: "An old but working flashlight.",
  examine_text: "The flashlight feels heavy in your hands. The batteries seem to have some charge left.",
)

brass_key = Web::Item.create!(
  soork: mine_soork,
  area: mining_chamber,
  name: "Brass Key",
  description: "A small brass key, tarnished with age.",
  examine_text: "The key has intricate engravings and feels substantial.",
)

brass_chest = Web::Item.create!(
  soork: mine_soork,
  area: storage_shed,
  name: "Brass Chest",
  description: "A locked brass chest sits in the corner.",
  examine_text: "The chest is beautifully crafted but securely locked. You need the right key to open it.",
  is_pickable: false
)

gold_nugget = Web::Item.create!(
  soork: mine_soork,
  area: storage_shed, # Will be revealed by opening the chest
  name: "Gold Nugget",
  description: "A genuine gold nugget from the mine's glory days.",
  examine_text: "The nugget gleams in the light. This must be worth a fortune!"
)

# Interactions for Abandoned Mine
# 1. Use flashlight in dark tunnel
Web::Interaction.create!(
  area: dark_tunnel,
  item: flashlight,
  target_name: nil,
  success_message: "The flashlight cuts through the darkness! You can now see much more of the tunnel.
   With light, you can see the tunnel continues deeper, with old mining tracks on the ground and timber supports 
   along the walls. Something glints in an alcove ahead.",
  effects: { "illuminate" => true },
  consumes_item: false
)

# 2. Use brass key on brass chest
Web::Interaction.create!(
  area: storage_shed,
  item: brass_key,
  target_name: "brass chest",
  success_message: "The key fits perfectly! The chest clicks open, revealing a shiny gold nugget inside.",
  effects: { "reveals_items" => ["Gold Nugget"] },
  consumes_item: false
)

# Create game sessions
digital_game = Web::GameSession.create!(
  user: user,
  soork: web_soork,
  current_area: entrance
)

mine_game = Web::GameSession.create!(
  user: user,
  soork: mine_soork,
  current_area: mine_entrance
)

puts "Created Web::Soork '#{web_soork.title}' with ID: #{web_soork.id}"
puts "Created Web::GameSession with ID: #{digital_game.id}"
puts "Created Web::Soork '#{mine_soork.title}' with ID: #{mine_soork.id}"  
puts "Created Web::GameSession with ID: #{mine_game.id}"