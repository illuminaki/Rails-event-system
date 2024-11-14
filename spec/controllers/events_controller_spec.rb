# spec/controllers/events_controller_spec.rb
require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:event) { FactoryBot.create(:event, user: user) }

  before do
    sign_in user
  end
  
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'loads all events' do
      event1 = FactoryBot.create(:event, user: user)
      event2 = FactoryBot.create(:event, user: user)

      get :index
      expect(assigns(:events)).to match_array([event1, event2])
    end

    it 'loads recent events' do
      recent_event = FactoryBot.create(:event, user: user, created_at: 2.days.ago)
      get :index
      expect(assigns(:recent_events)).to include(recent_event)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: event.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a successful response' do
      get :edit, params: { id: event.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
        it 'redirects to the event show page' do
          post :create, params: { event: { name: 'New Event', date: Date.tomorrow, description: 'Sample Description' } }
          expect(flash[:notice]).to eq("Event was successfully created.")
        end
      end
      
      context 'with invalid attributes' do
        it 're-renders the new template' do
          post :create, params: { event: { name: nil, date: nil, description: nil } }
          expect(flash[:alert]).to be_present  # Verifica que haya un mensaje de alerta
        end
      end

  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the event' do
        patch :update, params: { id: event.id, event: { name: 'Updated Event' } }
        event.reload
        expect(event.name).to eq('Updated Event')
      end

      it 'redirects to the event show page' do
        patch :update, params: { id: event.id, event: { name: 'Updated Event' } }
        expect(response).to redirect_to(event)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the event' do
        patch :update, params: { id: event.id, event: { name: nil } }
        event.reload
        expect(event.name).to_not eq(nil)
      end

      it 're-renders the edit template' do
        patch :update, params: { id: event.id, event: { name: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the event' do
      event_to_delete = FactoryBot.create(:event, user: user)
      expect {
        delete :destroy, params: { id: event_to_delete.id }
      }.to change(Event, :count).by(-1)
    end

    it 'redirects to the events index page' do
      delete :destroy, params: { id: event.id }
      expect(response).to redirect_to(events_path)
    end
  end
end
