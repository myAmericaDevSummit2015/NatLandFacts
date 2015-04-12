class FactsController < ApplicationController

  def show
    if params[:id].blank?
      @fact = Fact.validated.sample
    else
      @fact = Fact.find_by(id: params[:id])
      redirect_to root_path if @fact.nil? || @fact.pending? && !admin_signed_in?
    end
  end

  def another
    another_fact = Fact.validated.where.not(id: params[:id]).sample
    redirect_to action: :show, id: another_fact.try(:id) || params[:id]
  end

  def new
    @fact = Fact.new 
  end

  def create
    @fact = Fact.new(fact_params)

    if @fact.save
      flash[:notice] = "Your Fact has been submitted and is waiting for approval!"
      redirect_to action: :show
    else
      flash[:error] = "Your Fact could not be submitted."
      render :new
    end
  end

  private

  def fact_params
    params.require(:fact).permit(:fact_type, :title, :description, :state_name,
      :rec_area_id, :location_title, :location_description, :lat, :lng, :pic_url)
  end

end
