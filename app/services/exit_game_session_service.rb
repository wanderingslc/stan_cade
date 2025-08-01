class ExitGameSessionService
  def initialize(game_session)
    @game_session = game_session
  end

  def call
    # Logic to exit the game session
    @game_session.destroy
    { message: "You have exited the game session." }
  end
end