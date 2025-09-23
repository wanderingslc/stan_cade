class LookPlayerService
  def initialize(game_session)
    @game_session = game_session
  end

  def call
    current_area = @game_session.current_area
    {
      type: 'look',
      game_session_id: @game_session.id,
      current_area: {
        description: current_area.describe_area,
        name: current_area.name,
        exits: current_area.exits,
        items: items(current_area)
      }
    }
  end

  private

  def items(current_area)
    items = current_area.items.where.not(id: @game_session.items&.ids)
    if current_area.items.empty?
      "There is nothing to get here."
    elsif items.empty?
      "You have collected all items here."
    else
      items.map do |item|
        {
          name: item.name,
          description: item.description,
          examine_text: item.examine_text,
          properties: item.properties
        }
      end
    end
  end
end