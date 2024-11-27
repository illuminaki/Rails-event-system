# This class defines a background job to send a daily report of events created to admin users.
# It inherits from `ApplicationJob`, the base class for all Active Job jobs in Rails.
class DailyEventsReportJob < ApplicationJob

    # Specifies the queue in which this job will be enqueued.
    # The `:default` queue is used for general-purpose tasks.
    queue_as :default
  
    # The main method that will be executed when the job is triggered.
    def perform
      # Finds all events created on the current day.
      # `Date.today.all_day` ensures the search is limited to the full day (from 00:00 to 23:59).
      today_events = Event.where(created_at: Date.today.all_day)
  
      # Finds all users with a permission level of 1 (admin users).
      # These users are the recipients of the daily report email.
      admins = User.where(permission_level: 1)
  
      # Checks if there are any events created today and if there are admin users to notify.
      if today_events.any? && admins.any?
        # Sends an email to each admin with the list of events.
        admins.each do |admin|
          # The `daily_events_report` method in the EventMailer is used to format and send the email.
          # `deliver_now` sends the email synchronously.
          EventMailer.daily_events_report(admin, today_events).deliver_now
        end
      else
        # Logs a message if there are no events or no admins to notify.
        # This ensures visibility in the system logs for debugging or monitoring purposes.
        Rails.logger.info "No events or no admins to notify for the day #{Date.today}."
      end
    end

end  