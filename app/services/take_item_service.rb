class TakeItemService
  def initialize(game_session, command)
    @game_session = game_session
    @command = command
  end

  def call
    
    item = Web::Item.where("LOWER(name) ILIKE LOWER(?)", @command.gsub("take ", "").strip.downcase).first
    
    if item.nil?
      {
        type: 'no_item',
        message: "There is nothing to get here.",
        game_session_id: @game_session.id
      }
    elsif @game_session.has_item?(item)
      {
        type: 'item_already_taken',
        message: "You already have the #{item.name}.",
        game_session_id: @game_session.id
      }
    else
      @game_session.pick_up_item(item)
      {
        type: 'item_taken',
        message: "You picked up the #{item.name}.",
        game_session_id: @game_session.id,
        item: item
      } 
    end
  end
end