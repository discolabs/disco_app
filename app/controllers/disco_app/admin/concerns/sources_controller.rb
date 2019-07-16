module DiscoApp::Admin::Concerns::SourcesController

  extend ActiveSupport::Concern

  included do
    before_action :find_source, only: [:edit, :update, :destroy]
  end

  def index
    @sources = DiscoApp::Source.all
  end

  def new
    @source = DiscoApp::Source.new
  end

  def create
    @source = DiscoApp::Source.new(source_params)
    if @source.save
      redirect_to admin_sources_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @source.update(source_params)
      redirect_to edit_admin_plan_path(@source)
    else
      render 'edit'
    end
  end

  def destroy
    source.destroy
    redirect_to admin_sources_path
  end

  private

    def find_source
      @source = DiscoApp::Source.find(params[:id])
    end

    def source_params
      params.require(:source).permit(:source, :name)
    end

end
