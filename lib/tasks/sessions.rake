namespace :sessions do
  desc 'Clean out any stale sessions.'
  task clean: [:environment, 'db:load_config'] do
    threshold = (ENV['SESSIONS_CLEAN_THRESHOLD_DAYS'] || 30).to_i.days.ago
    ActiveRecord::Base.connection.execute("DELETE FROM #{ActiveRecord::SessionStore::Session.table_name} WHERE updated_at < '#{threshold}'")
  end
end
