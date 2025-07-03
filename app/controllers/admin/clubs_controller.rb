class Admin::ClubsController < Admin::BaseController
  before_action :set_club, only: [:show, :edit, :update, :destroy]

  def index
    @clubs = Club.includes(:users).order(:name)
  end

  def show
    @users = @club.users.order(:name)
  end

  def new
    @club = Club.new
  end

  def create
    @club = Club.new(club_params)
    
    if @club.save
      redirect_to admin_clubs_path, notice: "Club was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @club.update(club_params)
      redirect_to admin_clubs_path, notice: "Club was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @club.destroy
    redirect_to admin_clubs_path, notice: "Club was successfully deleted."
  end

  private

  def set_club
    @club = Club.find(params[:id])
  end

  def club_params
    params.require(:club).permit(:name, :slug, :city, :country, :active)
  end
end