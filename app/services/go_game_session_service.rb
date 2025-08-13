class GoGameSessionService
  def initialize(game_session, command)
    @game_session = game_session
    @command = command
  end

  def call

    direction = @command.split(" ").last
    current_area = @game_session.current_area
    connection = case direction
    when 'north' then current_area.north_connection
    when 'south' then current_area.south_connection
    when 'east' then current_area.east_connection
    when 'west' then current_area.west_connection
    else
      return {
        message: "Invalid direction. Please use north, south, east, or west."
      }
    end

    if connection
      @game_session.current_area = connection.target_area
      @game_session.save

      {
        type: 'move_area',
        message: "You moved to the #{direction}.",
        game_session_id: @game_session.id,
        current_area: {
          name: @game_session.current_area.name,
          description: @game_session.current_area.describe_area,
          exits: @game_session.current_area.exits
        } 
      }
    else
      {
        message: "You can't go that way."
      }
    end
  end
end