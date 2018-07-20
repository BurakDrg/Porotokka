Sidekiq.configure_client do |config|
  config.average_scheduled_poll_interval = 15
end

Sidekiq.configure_server do |config|
  config.average_scheduled_poll_interval = 15
end
