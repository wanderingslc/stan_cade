class WebStartGameService
  def initialize(soork_id, player_uuid = nil)

    @soork = Web::Soork.find_by(id: soork_id)
    @player_uuid = player_uuid

    if @soork
      start_new_game
    else
      @result = { message: "Soork not found" }
    end
  end

  def call
    @result
  end

  private

  def start_new_game
    start_area = @soork.areas.find_by(start_area: true)

    if start_area
      game_session = Web::GameSession.create(
        soork: @soork,
        current_area: start_area,
        player_uuid: @player_uuid
      )

      if game_session.persisted?
        @result = {
          message: 'Starting a new adventure!',
          game_session_id: game_session.id,
          current_area: {
            name: game_session.current_area.name,
            description: game_session.current_area.describe_area,
            exits: game_session.current_area.exits
          }
        }
      else
        @result = {message: "Failed to start new game session"}
      end
    else
      @result = { message: "Soork not found" }
    end
  end
end
