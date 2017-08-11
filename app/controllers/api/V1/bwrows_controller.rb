class Api::V1::BwrowsController < ApplicationController

  def index
    @bwrows = Bwrow.all
    render json: @bwrows
  end

  def show
    @bwrow = Bwrow.find_by(id: params[:id])
    render json: @bwrow
  end

  private

  def bwrow_params
    params.require(:bwrow).permit(
      :row
      )
  end

end
