class DiscoAppGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  def copy_root_files
    %w(.env .env.sample .gitignore .ruby-version Procfile).each do |file|
      copy_file "root/#{file}", file
    end
  end

end
