class Event < ApplicationRecord
    belongs_to :user

    # Validations
    validates :name, presence: true,  # Ensure that the name is present
    length: { in: 3..100 },  # Ensure the name length is between 3 and 100 characters
    format: { with: /\A[a-zA-Z0-9\s]+\z/, message: "only allows letters, numbers, and spaces" }  # Ensure name only contains letters, numbers, and spaces
    validates :date, presence: true  # Ensure that the date is present
    validates :description, presence: true, length: { maximum: 500 }  # Ensure the description is not too long
    validate :date_is_not_past # Ensure that the event date is not in the past
    validates :tickets_quantity, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validates :capacity, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    

    # Callbacks
    before_save :adjust_event_date  # Adjust event date before saving to ensure consistency
    before_validation :normalize_name  # Normalize the name (strip spaces and titleize) before validating
    after_save :log_event_creation  # Log event creation after the event has been saved
    after_create :send_welcome  # Send a welcome message after the event is created in logs console
    after_create :notify_ticket_creation # Callback para enviar la solicitud al endpoint externo


    # Scopes
    scope :added_in_last_30_days, -> { where('created_at >= ?', 30.days.ago) }  # Scope to fetch events created in the last 30 days

    # Scope for events in the next week (from next Monday to next Sunday)
    scope :in_next_week, -> {
        start_of_next_week = Date.current.beginning_of_week + 1.week  # Get the start of next week (Monday)
        end_of_next_week = start_of_next_week.end_of_week  # Get the end of next week (Sunday)
        where(date: start_of_next_week..end_of_next_week)  # Filter events within the next week
    }

    private

    # Custom validation method to check if the date is in the past
    def date_is_not_past
        if date.present? && date < Date.today - 7.days  # Cambiado a 7 días
            errors.add(:date, "cannot be more than 7 days in the past")
        end
    end

    # Adjust the event date to the start of the day if no time is provided
    def adjust_event_date
        self.date = date.beginning_of_day if date.present?  # Set the event date to the beginning of the day
    end

    # Normalize the name by stripping extra spaces and titleizing it
    def normalize_name
        self.name = name.strip.titleize if name.present?  # Remove leading/trailing spaces and format name in title case
    end

    # Log event creation in the Rails log for testing and debugging purposes
    def log_event_creation
        Rails.logger.info "Event '#{name}' created successfully at testing custom logs #{created_at}."  # Custom log message for event creation
    end

    # Send a welcome message (for now just logging to console) when a new event is created
    def send_welcome
        Rails.logger.info "Sending welcome in console server for the new event '#{name}'."  # Simulate sending a welcome message
    end

      # Callback para enviar la solicitud al endpoint externo
    def notify_ticket_creation
        payload = {
        event_id: id,
        user_id: user_id,
        tickets_quantity: tickets_quantity,
        capacity: capacity
        }

        # Llama al servicio para enviar los datos
        response = TicketCreationService.new(payload).call

        # Opcional: Maneja posibles errores y registra en los logs
        if response[:success]
        Rails.logger.info "Tickets successfully created for event '#{name}' with ID #{id}."
        else
        Rails.logger.error "Failed to create tickets for event '#{name}': #{response[:error]}"
        end
    end
end
