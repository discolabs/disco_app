namespace :database do
  desc 'update postgres sequence numbers in case database has been migrated'
  task update_sequences: :environment do
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
  end
end
