class Admin::UsersController < Admin::BaseController
  def index
    @users = User.includes(:club).order(:name)
  end
end