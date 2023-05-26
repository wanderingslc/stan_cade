require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get games_index_url
    assert_response :success
  end

  test "should get faune" do
    get games_faune_url
    assert_response :success
  end

  test "should get rabbit_jump" do
    get games_rabbit_jump_url
    assert_response :success
  end

  test "should get starfall" do
    get games_starfall_url
    assert_response :success
  end
end
