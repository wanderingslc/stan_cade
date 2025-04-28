class LookPlayerService
  def initialize(game_session)
    @game_session = game_session
  end

  def call
    current_room = @game_session.current_room
    {
      description: current_room.description,
      name: current_room.name,
      exits: available_exits(current_room),
      items: items(current_room)
    }
  end

  private

  def available_exits(current_room)
    exits = []
    exits << 'north' if current_room.north_connection
    exits << 'south' if current_room.south_connection
    exits << 'east' if current_room.east_connection
    exits << 'west' if current_room.west_connection
    exits
  end

  def items(current_room)
    items = current_room.items.reject(&:picked_up)
    if items.empty?
      "There is nothing to get here."
    else
      items.map do |item|
        {
          name: item.name,
          description: item.description,
          picked_up: item.picked_up,
          state: item.state
        }
      end
    end
  end
end