class UseItemService
  def initialize(game_session, command)
    @game_session = game_session
    @command = command
  end

  def call
    parsed = parse_use_command(@command)
    item = @game_session.get_item(parsed[:item_name])
    
    return {message: "You don't have that item"} if item.nil?

    result = @game_session.current_area.handle_item_use(
      item,
      parsed[:target_name],
      @game_session,
    )

    result
  end

  private

  def parse_use_command(command)
    item_part = command.gsub(/^use\s+/, "").strip.downcase

    if item_part.include?(" on ")
      parts = item_part.split(" on ", 2)
      {item_name: parts[0].strip, target_name: parts[1].strip}
    else
      {item_name: item_part, target_name: nil}
    end
  end
end
