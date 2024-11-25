class Api::V1::TicketsController < ApplicationController
    # @summary Crea tickets para un evento.
    # @parameter event_id(path) [Integer] ID del evento.
    # @parameter tickets_quantity(body) [Integer] Cantidad de tickets a crear.
    # @response Exitoso(200) [Hash{message: String, data: Hash}]
    # @response Evento no encontrado(404) [Hash{error: String}]
    # @response Error en la creación de tickets(422) [Hash{error: String}]
    def create
      event = Event.find(params[:event_id])
      return render json: { error: "Evento no encontrado" }, status: :not_found if event.nil?
  
      payload = {
        event_id: event.id,
        user_id: event.user_id,
        tickets_quantity: params[:tickets_quantity],
        capacity: event.capacity
      }
  
      response = TicketCreationService.new(payload).call
  
      if response[:success]
        event.update(tickets_quantity: params[:tickets_quantity])
        render json: { message: "Tickets creados exitosamente", data: response[:data] }, status: :ok
      else
        render json: { error: response[:error] }, status: :unprocessable_entity
      end
    end
  end
  