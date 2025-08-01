class StartGameService
  def initialize(soork_id, game_session_id = nil)
    @soork = Soork.find(soork_id)

    if @soork
      if game_session_id
      @game_session = GameSession.find(game_session_id) 
      end

      if @game_session
        {
          message: "Resuming game session",
          game_session_id: @game_session.id,
          current_room: {
            name: @game_session.current_room.name,
            description: @game_session.current_room.description
          }
        }
      else
        start_room = @soork.rooms.first

        if start_room
          game_session = GameSession.create(
            soork: @soork,
            current_room: start_room,
          )

          if game_session.persisted?
            {
              message: "Starting new game session",
              game_session_id: game_session.id,
              current_room: {
                name: game_session.current_room.name,
                description: game_session.current_room.description
              }
            }
          else
            {
              message: "Failed to start new game session"
            }
          end
        end
      end
    end
  end
end
