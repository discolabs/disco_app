task start: :environment do
  system 'bundle exec rails server -b 127.0.0.1 -p 3000'
end
