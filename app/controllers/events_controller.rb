class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events or /events.json
  def index
    @events = Event.all
    # Get events added in the last 30 days
    @recent_events = Event.added_in_last_30_days
    @upcoming_events = Event.in_next_week
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  def reserve_tickets
    event_id = params[:event_id]
    quantity = params[:quantity].to_i
  
    # Validar que la cantidad sea válida
    if quantity <= 0
      return render json: { error: "Invalid quantity" }, status: :bad_request
    end
  
    tickets = Ticket.per_event(event_id).where(statuses: 1).limit(quantity)
  
    # Validar si hay suficientes tickets disponibles
    if tickets.size < quantity
      return render json: { error: "Not enough tickets available" }, status: :range_not_satisfiable
    end
  
      if tickets.exists?
        ticket_data = tickets.map { |ticket| { id: ticket.id, serial: ticket.serial } }
    
        render json: {
          event_id: event_id,
          tickets: ticket_data
        }, status: :ok
      else
      render json: { error: "Event not found or no tickets available" }, status: :not_found
    end
  end
  
  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    @event = current_user.events.build(event_params)

    respond_to do |format|
      if @event.save
        SendEventEmailJob.perform_now(@event.id)
        format.html { redirect_to @event, notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        # mensaje de alerta cuando la creación falle
        flash[:alert] = "There was an error creating the event."
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_path, status: :see_other, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :date, :description, :capacity, :tickets_quantity)
    end
end
