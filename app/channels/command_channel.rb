class CommandChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "command_#{connection.connection_identifier}"

    soorks = Web::Soork.published.order(:created_at).pluck(:id, :title, :description)

    transmit({
      type: 'list_soorks',
      message: "Connected! Type 'play <number>' to begin your adventure, or 'help' for commands.",
      soorks: soorks.map { |id, title, description| { id: id, title: title, description: description } }
    })
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def execute_command(data)
  
    command = data['command']&.strip&.downcase
    game_session_id = data['game_session_id']
    
    response = GameCommandService.new(game_session_id, command, connection.connection_identifier).execute
# debugger
    transmit({
      type: response[:type],
      message: response[:message],
      game_session_id: response[:game_session_id],
      current_area: response[:current_area]
    })
  end
end
