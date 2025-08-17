class GamesController < ApplicationController
  def index
  end

  def faune
  end

  def rabbit_jump
  end

  def starfall
  end

  def sork
    cookies.permanent[:player_uuid] ||= SecureRandom.uuid
  end
end
