class Admin::FactsController < Admin::BaseController

  before_filter :find_fact, only: [:edit, :update, :destroy]

  def index
    @facts = Fact.paginate(page: params[:page], per_page: 10)
  end

  def edit
  end

  def update
    if @fact.update_attributes(fact_params)
      flash[:notice] = "The Fact has been updated!"
      redirect_to params[:continue].present? ? {action: :edit, id: @fact.id} : {action: :index}
    else
      flash[:error] = "An error occurred while updating the Fact."
      render :edit
    end
  end

  def destroy
    if @fact.destroy
      flash[:notice] = "The Fact has been deleted."
    else
      flash[:error] = @fact.errors.full_messages.first
    end
    redirect_to admin_facts_path
  end

  private

  def find_fact
    @fact = Fact.find params[:id]
  end

  def fact_params
    params.require(:fact).permit(:name)
  end

end