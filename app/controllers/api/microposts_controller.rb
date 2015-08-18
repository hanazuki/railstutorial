class Api::MicropostsController < Api::ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      render json: @micropost, status: :created
    else
      render_errors @micropost.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @micropost.destroy
    render json: "", status: :accepted
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    render json: "", status: :forbidden unless @micropost
  end
end
