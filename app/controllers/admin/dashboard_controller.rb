class Admin::DashboardController < Admin::BaseController
  def index
    @clubs_count = Club.count
    @users_count = User.count
    @recent_clubs = Club.order(created_at: :desc).limit(5)
    @recent_users = User.order(created_at: :desc).limit(5)
  end
end
