json.extract! event, :id, :nombre, :fecha, :descripcion, :created_at, :updated_at
json.url event_url(event, format: :json)
