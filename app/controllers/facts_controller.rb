class FactsController < ApplicationController

  def show
    @fact = Fact.last
  end

  def new
    @fact = Fact.new 
  end

  def create
    @fact = Fact.new(fact_params)

    if @fact.save
      flash[:notice] = "Your Fact has been submited and is waiting for approval!"
      redirect_to action: :index
    else
      flash[:error] = "An error occurred while creating your Fact."
      render :new
    end
  end

  private

  def fact_params
    params.require(:fact).permit(:title, :description)
  end

end
