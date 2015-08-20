class Api::UsersController < Api::ApplicationController
  before_action :logged_in_user,
    only: [:index, :update, :destroy, :following, :followers, :follow, :unfollow]
  before_action :correct_user, only: [:update]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    render_errors ["Account not activated"], status: :forbidden unless @user.activated
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      render json: "", status: :created  # まだActivateされてないので空っぽ返す
    else
      render_errors @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
    if @user && @user.update_attributes(user_params)
      render action: :show, status: :accepted
    else
      render_errors @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    render json: "", stauts: :accepted
  end

  def following
    user  = User.find(params[:id])
    @users = user.following.paginate(page: params[:page])

    render action: :index
  end

  def followers
    user  = User.find(params[:id])
    @users = user.followers.paginate(page: params[:page])

    render action: :index
  end

  def follow
    user = User.find(params[:id])
    current_user.follow(user) unless current_user.following? user

    render json: "", status: :created
  end

  def unfollow
    user = User.find(params[:id])
    current_user.unfollow(user) if current_user.following? user

    render json: "", status: :accepted
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Before filters

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    render_forbidden unless current_user?(@user)
  end

  # Confirms an admins user.
  def admin_user
    render_forbidden unless current_user.admin?
  end

  def render_forbidden
    render_errors ["You don't have permission to access"], status: :forbidden
  end
end
