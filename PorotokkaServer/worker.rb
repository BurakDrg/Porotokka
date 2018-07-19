require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { db: 1 }
end

class OurWorker
  include Sidekiq::Worker

  def perform(complexity)
    case(complexity)
    when "super_hard"
      sleep 20
      puts "20 lik"
    when "hard"
      sleep 10
      puts "10 luk"
    else
      sleep 1
      puts "1 lik"
    end
  end
end  
