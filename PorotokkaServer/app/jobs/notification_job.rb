class NotificationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    puts "tamammmmm"
  end
end
