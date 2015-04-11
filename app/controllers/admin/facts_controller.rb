class Admin::FactsController < Admin::BaseController

  before_filter :find_fact, only: [:edit, :update, :destroy]

  def index
    @facts = Fact.paginate(page: params[:page], per_page: 10)
  end

  def edit
  end

  def update
    if @fact.update_attributes(fact_params)
      flash[:notice] = "Fact updated"
      redirect_to params[:continue].present? ? edit_admin_fact_path(@fact) : admin_facts_path
    else
      flash[:error] = "Couldn't update the fact"
      render :edit
    end
  end

  def destroy
    if @fact.destroy
      flash[:notice] = "Fact deleted"
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