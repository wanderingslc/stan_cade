class GameCommandService
  def initialize(game_session_id, command, connection_id)
    @game_session_id = game_session_id
    @command = command
    @connection_id = connection_id
  end

  def execute
    
    if @game_session_id.nil?
      if @command.match(/^play (\d+)$/)
        soork_id = $1.to_i
        return start_new_game(soork_id)
      else
        return list_soorks
      end
    end

    game_session = Web::GameSession.find_by(id: @game_session_id)
    # debugger
    return list_soorks unless game_session

    result = ProcessCommandDispatcher.new(@command, game_session).process_command
    
    if @command == 'exit' || @command == 'quit'
      return list_soorks.merge(exit_message: result[:message])
    end

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

  def start_new_game(soork_id)
    result = WebStartGameService.new(soork_id).call

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
end
