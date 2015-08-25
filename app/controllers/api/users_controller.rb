class Api::UsersController < Api::ApplicationController
  before_action :set_current_user, except: [:create]
  before_action :set_user, only: [:show, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:update]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
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
    if @user && @user.update_attributes(user_params)
      render action: :show, status: :accepted
    else
      render_errors @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    render json: "", stauts: :accepted
  end

  def following
    @users = @user.following.paginate(page: params[:page])

    render action: :index
  end

  def followers
    @users = @user.followers.paginate(page: params[:page])

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

  def set_user
    id = params[:id]
    @user = (id == "me") ? @current_user : User.find(id)
  end

  # Confirms the correct user.
  def correct_user
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
