# app/channels/application_cable/connection.rb
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :player_uuid

    def connect
      self.player_uuid = cookies[:player_uuid]
      Rails.logger.info "=== CONNECTION ==="
      Rails.logger.info "Player UUID: #{self.player_uuid}"
    end
  end
end
