class TakeItemService
  def initialize(game_session, command)
    @game_session = game_session
    @command = command
  end

  def call
    binding.pry
    current_room = @game_session.current_room
    items = current_room.items.reject(&:picked_up)
    if items.empty?
    else
      
    end
  end
end