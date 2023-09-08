class EventReminderJob < ApplicationJob
  queue_as :default

  def perform(event_id, user_id)
    event = Event.find(event_id)
    user = User.find(user_id)
    EventMailer.event_reminder(event, user).deliver_now
  end
end