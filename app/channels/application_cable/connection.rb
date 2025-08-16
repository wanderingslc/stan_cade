# app/channels/application_cable/connection.rb
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :session_id

    def connect
      self.session_id = request.session.id
        Rails.logger.info "=== ALL COOKIES In initial connection ==="
        Rails.logger.info request.cookie_jar.inspect
      
      # Get game session from cookie (WebSocket can access this!)
      @game_session_id = connection_request.cookie_jar.signed[:game_session_id]
      
      Rails.logger.info "=== CONNECTION ==="
      Rails.logger.info "Game session from cookie: #{@game_session_id}"
      Rails.logger.info "=================="
    end

    def game_session_id
      @game_session_id
    end

    def connection_request
      request
    end

    def set_game_session_cookie(game_session_id)
      Rails.logger.info "BEFORE setting cookie - current cookies: #{request.cookie_jar.inspect}"
      
      request.cookie_jar.signed[:game_session_id] = {
        value: game_session_id,
        expires: 1.day.from_now
      }
      
      @game_session_id = game_session_id
      Rails.logger.info "AFTER setting cookie: game_session_id = #{game_session_id}"
      Rails.logger.info "Cookie jar now: #{request.cookie_jar.inspect}"
    end
  end
end
