class GoGameSessionService
  def initialize(game_session, command)
    @game_session = game_session
    @command = command
  end

  def call

    direction = @command.split(" ").last
    current_room = @game_session.current_room
    connection = case direction
    when 'north' then current_room.north_connection
    when 'south' then current_room.south_connection
    when 'east' then current_room.east_connection
    when 'west' then current_room.west_connection
    else
      return {
        message: "Invalid direction. Please use north, south, east, or west."
      }
    end

    if connection
      @game_session.current_room = connection.target_room


      {
        message: "You moved to the #{direction}.",
        room: {
          name: @game_session.current_room.name,
          description: @game_session.current_room.description,
          items: @game_session.current_room.items.map do |item|
            {
              name: item.name,
              description: item.description
            }
          end
        }
      }
    else
      {
        message: "You can't go that way."
      }
    end
  end
end