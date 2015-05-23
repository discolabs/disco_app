class DiscoAppGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  def copy_gitignore
    copy_file '.gitignore', '.gitignore'
  end

  def copy_env_files
    %w(.env .env.sample).each do |filename|
      copy_file '.env.sample', filename
    end
  end

end
