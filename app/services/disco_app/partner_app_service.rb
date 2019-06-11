module DiscoApp
  class PartnerAppService

    def initialize(params)
      @email = params[:email]
      @password = params[:password]
      @app_name = params[:app_name]
      @app_url = params[:app_url]
      @organization = params[:organization]

      @agent = Mechanize.new do |a|
        a.user_agent_alias = 'Mac Safari'
        a.follow_meta_refresh = true
        a.keep_alive = false
        a.pre_connect_hooks << lambda do |_agent, request|
          request['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
        end
      end
    end

    def generate_partner_app
      begin
        # Login to Shopify Partners
        login
        # Access Partner dashboard
        org_link = organizations
        dashboard = dashboard_page(org_link)
        # Create App
        apps_page = refresh_page(dashboard)
        create_partner_app(apps_page)
        # Configure newly created app with embedded app use
        apps_page = refresh_page(dashboard)
        embedded_admin_app(apps_page)
        # Add Disco App icon
        apps_page = refresh_page(dashboard)
        add_disco_icon(apps_page)
        # Fetch API credentials
        apps_page = refresh_page(dashboard)
        api_key, secret = api_credentials(apps_page)
      rescue Mechanize::Error => e
        puts 'Error while trying to create partner app'
        puts "Error #{e}, message : #{e.message}"
        return
      end
      # Add them to .env.local file
      append_credentials(api_key, secret)
      puts '#' * 80
      puts 'New Partner App successfully created!'
      puts 'API Credentials have been pasted to your .env.local file'
      puts '#' * 80
    end

    private

      def login
        @agent.get('https://accounts.shopify.com/login') do |page|
          page.form do |form|
            form['account[email]'] = @email
            form['account[password]'] = @password
          end.submit
        end
      end

      def organizations
        organizations = @agent.get('https://partners.shopify.com/organizations/')
        organizations.links.select { |link| link.text[/#{@organization}/] }.first.href
      end

      def dashboard_page(org_link)
        @agent.get('https://partners.shopify.com' + org_link)
      end

      def create_partner_app(apps_page)
        apps_page.form do |form|
          # App name
          form['create_form[title]'] = @app_name

          # App URL
          form['create_form[application_url]'] = @app_url

          # Accept TOS
          unless form['create_form[accepted]'].blank?
            form['create_form[accepted]'] = '1'
            form.hiddens.last.value = 1
          end
        end.submit
      end

      def api_credentials(apps_page)
        app = apps_page.link_with(text: @app_name).click
        app_info = app.link_with(text: 'App info').click
        add_whitelist_url(app_info)
        api_key = app_info.search('#api_key').first.values[3]
        secret = app_info.search('#settings_form_secrets').first.values[3]
        [api_key, secret]
      end

      def embedded_admin_app(apps_page)
        app = apps_page.link_with(text: @app_name).click
        extensions = app.link_with(text: 'Extensions').click
        extensions.form do |form|
          form['extensions_form[embedded]'] = '1'
        end.submit
      end

      def add_disco_icon(apps_page)
        app = apps_page.link_with(text: @app_name).click
        app_info = app.link_with(text: 'App info').click
        logo = DiscoApp::Engine.root.join('app', 'assets', 'images', 'disco_app', 'logo.png').to_s
        app_info.form do |form|
          form.file_uploads.first.file_name = logo
        end.submit
      end

      # Write credentials of newly created app to .env.local file
      def append_credentials(api_key, secret)
        original_file = '.env.local'
        new_file = original_file + '.new'
        File.open(new_file, 'w') do |file|
          File.foreach(original_file) do |line|
            if line.include?('SHOPIFY_APP_API_KEY')
              file.puts "SHOPIFY_APP_API_KEY=#{api_key}"
            elsif line.include?('SHOPIFY_APP_SECRET')
              file.puts "SHOPIFY_APP_SECRET=#{secret}"
            else
              file.puts line
            end
          end
        end
        File.delete(original_file)
        File.rename(new_file, original_file)
      end

      def add_whitelist_url(app_info)
        app_info.form do |form|
          form['info_form[redirect_url_whitelist]'] = callback_url
        end.submit
      end

      # Access the "Apps" section of the dashboard, also used to reload the dashboard
      # When an action has been taken
      def refresh_page(dashboard)
        dashboard.link_with(text: '  Apps').click
      end

      def callback_url
        [@app_url + '/auth/shopify/callback', @app_url + '/auth/shopify_user/callback'].join("\n")
      end

  end
end
