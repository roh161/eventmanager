class EventMailer < ApplicationMailer
    def event_reminder(event, user)
      @event = event
      @user = user
      mail(to: @user.email, subject: 'Event Reminder')
    end
  end