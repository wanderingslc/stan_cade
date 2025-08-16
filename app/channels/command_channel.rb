class CommandChannel < ApplicationCable::Channel
  def subscribed

    stream_from "command_#{connection.connection_identifier}"

    existing_session_id = connection.game_session_id
    Rails.logger.info "Found game session from cookie: #{existing_session_id}"



    soorks = Web::Soork.published.order(:created_at).pluck(:id, :title, :description)
    # debugger
    if existing_session_id
      begin
        game_session = Web::GameSession.find(existing_session_id)
        transmit({
          type: 'resume_available',
          message: "Welcome back! You have a game in progress. Type 'resume' to continue or 'play <number>' to start new",
          soorks: soorks.map { |id, title, description| { id: id, title: title, description: description }},
          existing_game: {
            id: game_session.id,
            title: game_session.title,
            description: game_session.description,
            current_area: game_session.current_area
          }
        })
      rescue ActiveRecord::RecordNotFound
        connection.session[:game_session_id] = nil
        send_normal_welcome(soorks)
      end
    else
      send_normal_welcome(soorks)
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def execute_command(data)
  
    command = data['command']&.strip&.downcase
    game_session_id = data['game_session_id']
    
    response = GameCommandService.new(game_session_id, command, connection).execute
# debugger
    transmit({
      type: response[:type],
      message: response[:message],
      game_session_id: response[:game_session_id],
      current_area: response[:current_area]
    })
  end

  private

  def send_normal_welcome(soorks)
    transmit({
      type: 'list_soorks',
      message: "Welcome to the Soork (SOrt Of Zork)! Type 'play <number>' to begin your adventure, or 'help' for commands.",
      soorks: soorks.map { |id, title, description| { id: id, title: title, description: description } }
    })
  end
end
