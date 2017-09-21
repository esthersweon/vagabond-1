class UsersController < ApplicationController
  before_action :verify_user, only: [:edit, :update]
  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      redirect_to user_path(@user)
    else
      flash[:error] = @user.errors.full_messages.join(" ")
      render new_user_path
    end
  end

  def show
    @user = User.find_by_id(params[:id])
    if @user == nil
      flash[:error] = "User does not exist"
      redirect_to root_path
    end

  end

  def edit
    @user = User.find_by_id(params[:id])
  end

  def update
    @user = User.find_by_id(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      flash[:error] = @user.errors.full_messages.join(" ")
      redirect_to user_path(@user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :current_city, :password)
  end

  def verify_user
    if current_user[:id].to_s != params[:id].to_s
      flash[:notice] = "No permission to edit other user information"
      redirect_to user_path
    end
  end

end
