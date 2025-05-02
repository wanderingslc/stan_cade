class TakeItemService
  def initialize(game_session, command)
    @game_session = game_session
    @command = command
  end

  def call
    item = Item.where("LOWER(name) ILIKE LOWER(?)", @command.gsub("take ", "").strip.downcase).first

    current_room = @game_session.current_room
    room_items = current_room.items
    room_items.each do |room_item|
      if !@game_session.has_item?(room_item)
        item = room_item
      end
    end
   
    
    if item.nil?
      {
        message: "There is nothing to get here.",
      }
    elsif @game_session.has_item?(item)
      {
        message: "You already have the #{item.name}.",
      }
    else
      @game_session.pick_up_item(item)
      {
        message: "You picked up the #{item.name}.",
        item: item
      } 
    end
  end
end