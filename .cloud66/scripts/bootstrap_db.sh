bundle exec rake db:migrate
bundle exec rake db:seed

bundle exec rake environment tire:import CLASS='Media' FORCE=true
bundle exec rake environment tire:import CLASS='Post' FORCE=true