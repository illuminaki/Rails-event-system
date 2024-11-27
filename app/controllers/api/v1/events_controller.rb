class Api::V1::EventsController < ApplicationController
    # @summary Obtiene información de un evento por su ID.
    # @parameter id(path) [Integer] ID del evento.
    # @response Exitoso(200) [Hash{message: String, data: Hash}]
    # @response Evento no encontrado(404) [Hash{error: String}]
    def show
      event = Event.find_by(id: params[:id])
      if event
        render json: {
          message: "Evento encontrado",
          data: {
            id: event.id,
            name: event.name,
            date: event.date,
            description: event.description,
            tickets_quantity: event.tickets_quantity,
            capacity: event.capacity,
            created_at: event.created_at,
            updated_at: event.updated_at
          }
        }, status: :ok
      else
        render json: { error: "Evento no encontrado" }, status: :not_found
      end
    end
  
end
    