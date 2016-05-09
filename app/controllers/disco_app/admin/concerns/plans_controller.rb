module DiscoApp::Admin::Concerns::PlansController
  extend ActiveSupport::Concern

  included do
    before_action :find_plan, only: [:edit, :update, :destroy]
  end

  def index
    @plans = DiscoApp::Plan.all
  end

  def new
    @plan = DiscoApp::Plan.new
    @plan.plan_codes.build
  end

  def create
    @plan = DiscoApp::Plan.new(plan_params)
    if @plan.save
      redirect_to admin_plans_path
    else
      render 'new'
    end
  end

  def edit
    @plan.plan_codes.build
  end

  def update
    if @plan.update_attributes(plan_params)
      redirect_to admin_plans_path
    else
      render 'edit'
    end
  end

  def destroy
    @plan.destroy
    redirect_to action: :index
  end

  private

    def find_plan
      @plan = DiscoApp::Plan.find(params[:id])
    end

    def plan_params
      params.require(:plan).permit(
        :name, :status, :plan_type, :trial_period_days, :amount,
        :plan_codes_attributes => [:code, :trial_period_days, :amount]
      )
    end

end
