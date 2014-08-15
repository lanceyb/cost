class UsersController < ApplicationController
  authorize_resource

  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      redirect_to users_path, notice: "成功更新用户：【#{@user.login}】"
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: "成功删除用户：【#{@user.login}】"
    else
      redirect_to users_path, alert: "无法删除用户：【#{@user.login}】"
    end
  end

  def create
    @user = User.new user_params

    if @user.save
      redirect_to users_path, notice: "成功添加用户：【#{@user.login}】"
    else
      render :new
    end
  end

  private
    def user_params
      params.require(:user).permit(:login, :password, :password_confirmation, :role)
    end

    def set_user
      @user = User.find params[:id]
    end
end
