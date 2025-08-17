class CommandChannel < ApplicationCable::Channel
  def subscribed

    stream_from "command_#{connection.connection_identifier}"

    
    Rails.logger.info "Found player UUID from cookie: #{player_uuid}"

    existing_sessions = Web::GameSession.where(player_uuid: player_uuid)

    soorks = Web::Soork.published.order(:created_at).pluck(:id, :title, :description)
 
    if existing_sessions.any?
      begin
        transmit({
          type: 'resume_available',
          message: "Welcome back! You have a game in progress. Type 'resume <number>' to continue or 'play <number>' to start new",
          soorks: soorks.map { |id, title, description| { id: id, title: title, description: description }},
          existing_games: existing_sessions.map { |session| {
            id: session.id,
            title: session.soork.title,
            description: session.soork.description,
            current_area: session.current_area
          }}
        })
      rescue ActiveRecord::RecordNotFound
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
  
    response = GameCommandService.new(game_session_id, command, connection, player_uuid).execute

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
