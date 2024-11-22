class Api::V1::TicketsController < ApplicationController
   
    def create
        event = Event.find(params[:event_id])

        if event.nil?
            render json: { error: "Evento no encontrado" }, status: :not_found
            return
        end

        # Enviar datos a la API externa
        payload = {
            event_id: event.id,
            user_id: event.user_id,
            tickets_quantity: params[:tickets_quantity],
            capacity: event.capacity
            
        }

        response = TicketCreationService.new(payload).call

        if response[:success]
            # Actualizar el evento con la cantidad de tickets creados
            event.update(tickets_quantity: params[:tickets_quantity])

            render json: { message: "Tickets creados exitosamente", data: response[:data] }, status: :ok
        else
         render json: { error: response[:error] }, status: :unprocessable_entity
        end
    end
      
end
