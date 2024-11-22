module Api::V1::TicketsHelper
    class TicketsController < ApplicationController
        class TicketsController < ApplicationController
            def create
              event = Event.find_by(id: params[:event_id])
      
              if event.nil?
                render json: { error: "Evento no encontrado" }, status: :not_found
                return
              end
      
              # Datos para enviar a la otra API
              payload = {
                event_id: event.id,
                user_id: event.user_id,
                tickets_count: params[:tickets_count]
              }
      
              # Enviar datos a la otra API
              response = TicketCreationService.new(payload).call
      
              if response[:success]
                # Actualizar la tabla con los datos devueltos
                event.update(tickets_response: response[:data])
      
                render json: { message: "Tickets creados exitosamente", data: response[:data] }, status: :ok
              else
                render json: { error: response[:error] }, status: :unprocessable_entity
              end
            end
          end
    end
  end