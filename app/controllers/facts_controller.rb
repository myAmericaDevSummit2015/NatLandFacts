class FactsController < ApplicationController

  def show
    @fact = Fact.last
  end

end
