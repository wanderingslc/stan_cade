class SoorksController < ApplicationController 
 

  def index 
    @soorks = Soork.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @soorks }
    end
  end

  def process_command
    @game_session = GameSession.find(params[:game_session_id])
    
    @command = params[:command]
    result = ProcessCommandDispatcher.new(@command, @game_session)
    
    render json: serialize(result), status: :ok
  end

  def start
    soork = Soork.find(params[:soork_id])
    if soork 
      if session[:current_game_session_id]
        @game_session = GameSession.find_by(id: session[:current_game_session_id])
      end

      if @game_session
        render json: {
          message: "Resuming game session",
          game_session_id: @game_session.id,
          current_room: {
            name: @game_session.current_room.name,
            description: @game_session.current_room.description
          }
        }, status: :ok
      else
        start_room = soork.rooms.first    
    
        if start_room
          @game_session = GameSession.create(
            soork: soork,
            current_room: start_room,
          )
  
          session[:current_game_session_id] = @game_session.id
          render json: {
            message: "New game session started",
            game_session_id: @game_session.id,
            current_room: {
              name: start_room.name,
              description: start_room.description   
          }
        }, status: :ok
        end
      end
    end
  end

  

  private

  def serialize(result) 
    {
      command: @command,
      result: result.process_command,
      game_session_id: @game_session.id,
      current_room: {
        name: @game_session.current_room.name,
        description: @game_session.current_room.description
      },
     
      }
  end

  def set_user
    @user = current_user
  end

  def authenticate_user!
    unless user_signed_in?
      flash[:alert] = "You must be signed in to access this page."
      redirect_to new_user_session_path
    end
  end
end
