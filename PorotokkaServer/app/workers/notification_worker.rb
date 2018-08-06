require 'sidekiq'

class NotificationWorker
  include Sidekiq::Worker

  def perform(eventName)
    fcm_client = FCM.new("AAAAcIjcbiM:APA91bH2h-Y5b20cq72sZPC9rLPvkJMGRFvPDf8ONZzhmeoJj-L7zbhtStJdKVnCeNUB3sqzdiBW6AyRnIwjhAxmOzZ9oO9e-RK1Ym3Tk9LC3oqQYx6UhiaYSlA9Z1ScYNcEfUDtMEbg_E3PnMn9Qe3uoKyua5b-oQ")
    eventName = eventName + " soon"
     options = {priority: 'high', notification: {body: eventName,sound: 'default',icon: ""}}

     device_ids=["eWz7xsbHr2Q:APA91bGvP_DaPEUpXdsd3ButywJm8BQE21CNAyPXuaM2sbDBHWRjNr8-z1mXJ0tbdfB2izgf3cOiEp9HyIqKSzKk_WCQXVsKPoaqfqY2DFuXZLj2psXPrCmcAAmAD2mFpptlXn18MKy4HfO_oo93MAGqOZ4xhHAA3Q"]
     response =  fcm_client.send(device_ids, options)
  end
end
