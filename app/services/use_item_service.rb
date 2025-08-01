class UseItemService
  def initialize(game_session, command)
    @game_session = game_session
    @command = command
  end

  def call
    item = @game_session.get_item(@command.gsub("use ", "").strip.downcase)
    if item.nil?
      {
        message: "You don't have that item.",
      }
    elsif @game_session.use_item(item)
      {
        message: "You used the #{item.name}.",
        item: item
      }
    else
      {
        message: "You can't use that item.",
      }
    end
  end
end
