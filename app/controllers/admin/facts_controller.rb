class Admin::FactsController < Admin::BaseController

  before_filter :find_fact, only: [:edit, :update, :destroy, :validate]

  def index
    @facts = Fact.validated.most_recent.paginate(page: params[:page], per_page: 10)
    @pending_facts = Fact.pending.most_recent
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
    redirect_to action: :index
  end

  def validate
    @fact.touch(:validated_at)
    flash[:notice] = "The Fact has been approved!"
    redirect_to action: :index
  end

  private

  def find_fact
    @fact = Fact.find params[:id]
  end

  def fact_params
    params.require(:fact).permit(:title, :description)
  end

end