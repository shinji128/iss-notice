# Rails.rootを使用するために必要
require File.expand_path("#{File.dirname(__FILE__)}/environment")
# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development
# cronを実行する環境変数をセット
set :environment, rails_env
# cronのログの吐き出し場所
set :output, "#{Rails.root}/log/cron.log"
ENV.each { |k, v| env(k, v) }

job_type :rake, "export PATH=\"$HOME/.rbenv/bin:$PATH\";eval \"$(rbenv init -)\"; cd :path && RAILS_ENV=:environment bundle exec rake :task :output"

every 1.day, { at: '9:00' } do
  rake 'line_notice:iss_lookup_time'
end
