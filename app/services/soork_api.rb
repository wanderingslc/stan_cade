class SoorkApi
  def look(game_session)
    current_room = game_session.current_room
    {
      description: current_room.description,
      name: current_room.name,
      exits: available_exits(current_room),
      items: items(current_room)
    }
  end

  private




end