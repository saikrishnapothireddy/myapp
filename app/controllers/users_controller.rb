class UsersController < ApplicationController
  #before_action :set_user, only: %i[ show edit update destroy ]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  # GET /users or /users.json
  def index
    @users = User.paginate(page: params[:page])
  end

  # GET /users/1 or /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Sai welcome's you to sample app!"
      # format.html { redirect_to user_url(@user) }
      # format.json { render :show, status: :created, location: @user }
    else
      render 'new'
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    if @user.update(user_params)
      flash[:success] = "User was successfully updated."
      redirect_to user_url(@user)
      # format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
      # format.json { render :show, status: :ok, location: @user }
    else
      # format.html { render :edit, status: :unprocessable_entity }
      # format.json { render json: @user.errors, status: :unprocessable_entity }
      render 'edit'
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    # @user.destroy
    # flash[:success] = "User deleted successfully."
    # redirect_to users_url
    User.find(params[:id]).destroy
    flash[:success] = "User deleted successfully."
    redirect_to users_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
