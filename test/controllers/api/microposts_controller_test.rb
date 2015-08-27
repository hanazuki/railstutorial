require 'test_helper'

class Api::MicropostsControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
    @micropost = microposts(:orange)
    @request.headers["Authorization"] = token_for(@user)
  end

  test 'should return created micropost as json' do
    post :create, micropost: {content: "Lorem ipsum"}, format: :json

    json = JSON.parse(response.body)

    assert_equal 201, response.status

    assert_equal "Lorem ipsum", json["content"]
    assert_equal @user.id, json["user"]["id"]
    assert_not_nil json["created_at"]
  end

  test 'should return errors when params are invalid' do
    post :create, micropost: {content: ""}, format: :json

    json = JSON.parse(response.body)

    assert_equal 422, response.status
    assert json["errors"].member? "Content can't be blank"
  end

  test 'should return 202 when deleted the micropost' do
    delete :destroy, id: @micropost, format: :json

    assert_equal 202, response.status
  end

  test 'should return 401 if auth token is missing' do
    @request.headers["Authorization"] = ""

    post :create, micropost: {content: "Lorem inpsum"}, format: :json

    json = JSON.parse(response.body)

    assert_equal 401, response.status
    assert json["errors"].member? "Unauthorized"
  end

  test 'should return 403 if current_user is not the owner' do
    @request.headers["Authorization"] = token_for(users :archer)

    delete :destroy, id: @micropost, format: :json

    assert_equal 403, response.status
  end
end
