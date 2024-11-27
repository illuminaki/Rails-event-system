json.extract! event, :id, :name, :date, :description, :tickets_quantity, :capacity, :user_id, :created_at, :updated_at
json.url event_url(event, format: :json)
