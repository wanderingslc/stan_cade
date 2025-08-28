class ShowInventoryService
  def initialize(game_session)
    @game_session = game_session
  end

  def call
    {
      type: 'inventory',
      game_session_id: @game_session.id,
      message: @game_session.items.map { |item| { id: item.id, name: item.name, description: item.description } }
    }
  end
end