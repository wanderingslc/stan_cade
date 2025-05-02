class ProcessCommandDispatcher
  def initialize(command, game_session)
    @command = command
    @game_session = game_session
  end

  def process_command
    
    case @command
    when 'look'
      LookPlayerService.new(@game_session).call
    when /^take/
      TakeItemService.new(@game_session, @command).call
    when /^go (north|south|east|west)$/
      GoGameSessionService.new(@game_session, @command).call
    else 
      puts "Command not recognized."
    end
  end 
end

