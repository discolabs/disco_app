module DiscoApp::Admin::Concerns::AppSettingsController

  extend ActiveSupport::Concern

  def edit
    @app_settings = DiscoApp::AppSettings.instance
  end

  def update
    @app_settings = DiscoApp::AppSettings.instance
    if @app_settings.update(app_settings_params)
      flash[:success] = 'Settings updated.'
      redirect_to edit_admin_app_settings_path
    else
      render 'edit'
    end
  end

  private

    def app_settings_params
      params.require(:app_settings)
    end

end
