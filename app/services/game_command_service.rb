class GameCommandService
  def initialize(game_session_id, command, connection, player_uuid = nil)
    @game_session_id = game_session_id
    @command = command
    @connection = connection
    @player_uuid = player_uuid
  end

  def execute

    if @game_session_id.blank?
      if @command.match(/^play (\d+)$/)
        soork_id = $1.to_i
        return start_new_game(soork_id, @player_uuid)
      elsif @command.match(/^resume (\d+)$/)
        game_session_id = $1.to_i
        return resume_game(game_session_id, @player_uuid)
      else
        return list_soorks
      end
    end

    game_session = Web::GameSession.find_by(id: @game_session_id)
    
    return list_soorks unless game_session

    result = ProcessCommandDispatcher.new(@command, game_session).process_command

    result
  end

  private

  def list_soorks
    soorks = Web::Soork.published.order(:created_at).pluck(:id, :title, :description)
    # todo: Is this actually being used?
    {
      type: 'soorks_list',
      soorks: soorks.map { |id, title, description| { id: id, title: title, description: description } },
    }
  end

  def start_new_game(soork_id, player_uuid)
 
    result = WebStartGameService.new(soork_id, player_uuid).call

    if result[:game_session_id]
      {
        type: 'game_started',
        message: result[:message],
        game_session_id: result[:game_session_id],
        current_area: result[:current_area]
      }
    else
      {
        type: 'error',
        message: result[:message]
      }
    end
  end

  def resume_game(game_session_id, player_uuid)
    
    game_session = Web::GameSession.find_by(id: game_session_id)

    if game_session
      {
        type: 'game_resumed',
        message: "Resuming game session #{game_session_id}...",
        game_session_id: game_session.id,
        current_area: {
          name: game_session.current_area.name,
          description: game_session.current_area.describe_area,
          exits: game_session.current_area.exits
        }
      }
    else
      {
        type: 'error',
        message: "Game session #{game_session_id} not found."
      }
    end
  end
end
