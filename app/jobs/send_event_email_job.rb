# This class defines a background job to send an email notification when an event is created.
# It inherits from `ApplicationJob`, which is the base class for all Active Job jobs in Rails.
class SendEventEmailJob < ApplicationJob

  # Specifies the queue in which this job will be enqueued.
  # The `:default` queue is typically used for general-purpose tasks.
  queue_as :default

  # Defines the task to be performed when the job is executed.
  # It accepts an `event_id` as a parameter to identify the event for which the email should be sent.
  def perform(event_id)
    # Finds the event by its ID. If the event doesn't exist, `nil` is returned.
    event = Event.find_by(id: event_id)

    # Checks if the event was found.
    if event
      # Sends the "event created" email immediately using the EventMailer.
      EventMailer.event_created(event).deliver_now
    else
      # Logs an error message if the event could not be found in the database.
      Rails.logger.error "Event with ID #{event_id} not found."
    end
  end
  
end
