require 'test_helper'

class Api::MicropostsControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
    @micropost = microposts(:orange)
    @request.headers["Authorization"] = token_for(@user)
  end

  test 'should return created micropost as json' do
    post :create, micropost: {content: "Lorem ipsum"}

    json = JSON.parse(response.body)

    assert_equal 201, response.status

    assert_equal "Lorem ipsum", json["content"]
    assert_equal @user.id, json["user_id"]
    assert_not_nil json["created_at"]
    assert_not_nil json["updated_at"]
  end

  test 'should return errors when params are invalid' do
    post :create, micropost: {content: ""}

    json = JSON.parse(response.body)

    assert_equal 422, response.status
    assert json["errors"].member? "Content can't be blank"
  end

  test 'should return 202 when deleted the micropost' do
    delete :destroy, id: @micropost

    assert_equal 202, response.status
  end

  test 'should return 401 if auth token is missing' do
    @request.headers["Authorization"] = ""

    post :create, micropost: {content: "Lorem inpsum"}

    json = JSON.parse(response.body)

    assert_equal 401, response.status
    assert json["errors"].member? "Unauthorized"
  end

  test 'should return 403 if current_user is not the owner' do
    @request.headers["Authorization"] = token_for(users :archer)

    delete :destroy, id: @micropost

    assert_equal 403, response.status
  end
end