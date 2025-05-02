class SoorkCli
  attr_reader :player, :current_room

  def initialize(soork_player)
    @player = soork_player
    @current_room = @player.current_room
  end

  def start
    puts "\nWelcome to #{player.soork.title}!"
    look
    game_loop
  end

  private

  def game_loop
    loop do
      print "\n>"
      response = STDIN.gets.chomp.downcase
      command, object = response.split(' ', 2)
      if command == "use" && object.include?(" on ")
        items =  object.match(/(.+) on (.+)/)
      end

      case command
      when 'quit', 'q', 'exit'
        puts "Thanks for playing!"
        break
      when 'look', 'l'
        look
      when 'north', 'n'
        move('north')
      when 'south', 's'
        move('south')
      when 'east', 'e'
        move('east')
      when 'west', 'w'
        move('west')
      when 'inventory', 'i'
        show_inventory
      when 'get', 'g'
        get_item(ARGV[1])
      when 'use'
        if items
          use_items(items[1], items[2])
          else
          use_item(object)
        end
      when 'help', 'h', '?'
        show_help
      else
        puts "I don't understand that command. Type 'help' for a list of commands."
      end
    end
  end

  def look
    puts "\n#{current_room.name}"
    puts "-" * current_room.name.length
    puts @current_room.description

    exits = available_exits
    puts "\nExits: #{exits.join(', ')}" unless exits.empty?

    items = @current_room.items
    unless items.empty? || items.reject(&:picked_up).empty?
      puts "/nYou can see: #{items.count} items, "
      items.each {|item| puts item.name unless item.picked_up}
    end
  end

  def move(direction)
    connection = case direction
                 when 'north' then @current_room.north_connection
                 when 'south' then @current_room.south_connection
                 when 'east' then @current_room.east_connection
                 when 'west' then @current_room.west_connection
                 else nil
                 end

    if connection
      @current_room = connection.target_room
      player.visit_room(@current_room)
      look
    else
      puts "You can't go that way."
    end
  end

  def get_item(name)
    items = @current_room.items.reject(&:picked_up)
    if items.empty?
      puts "There is nothing to get here."
    else
      items.each do |item|
        player.pick_up_item(item)
        puts "You take the #{item.name}"
        item.picked_up = true
        item.state = "active"
      end
    end
  end

  def available_exits
    exits = []
    exits << 'north' if @current_room.north_connection
    exits << 'south' if @current_room.south_connection
    exits << 'east' if @current_room.east_connection
    exits << 'west' if @current_room.west_connection
    exits
  end

  def show_inventory
    items = player.player_items
    if items.empty?
      puts "You aren't carrying anything"
    else
      puts "\nYou are carrying: #{items.count} items, "
      items.each {|item| puts " - #{item.item.name}"}
    end
  end

  def use_item(item_name)
    item = player.find_item_by_name(item_name)
    if item.nil?
      puts "You don't have that item"
    else
      item.use
    end
  end

  def use_items(player_string, room_string)
    player_item = player.find_item_by_name(player_string)
    room_item = @current_room.by_name( room_string)
    if player_item.nil?
      puts "You don't have that item"
    elsif room_item.nil?
      puts "That item isn't here"
    else
      if player_item.properties["unlocks"] == room_item.name
        print "You win!"
        exit
      else
        print "You lose!"
        exit
      end
    end

  end

  def show_help
    puts "\nAvailable commands:"
    puts "  look (l)      - Look around the current room"
    puts "  north (n)     - Go north"
    puts "  south (s)     - Go south"
    puts "  east (e)      - Go east"
    puts "  west (w)      - Go west"
    puts "  inventory (i) - Show your inventory"
    puts "  get (g)       - Pick up an item"
    puts "use <item>     - Use an item on <item>, use brass key on lockbox"
    puts "  help (h, ?)   - Show this help message"
    puts "  quit (q)      - Exit the game"
  end
end