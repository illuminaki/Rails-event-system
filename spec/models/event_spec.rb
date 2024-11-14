# spec/models/event_spec.rb
require 'rails_helper'

RSpec.describe Event, type: :model do
    let(:user) { FactoryBot.create(:user) }

    describe 'validations' do
        it 'is valid with valid attributes' do
            event = Event.new(name: 'Sample Event', date: Date.tomorrow, description: 'This is a sample event.', user: user)
            expect(event).to be_valid
        end

        it 'is not valid without a name' do
            event = Event.new(name: nil, date: Date.tomorrow, description: 'This is a sample event.', user: user)
            expect(event).not_to be_valid
        end

        it 'is not valid with a name shorter than 3 characters' do
            event = Event.new(name: 'ab', date: Date.tomorrow, description: 'This is a sample event.', user: user)
            expect(event).not_to be_valid
        end

        it 'is not valid with a name longer than 100 characters' do
            event = Event.new(name: 'a' * 101, date: Date.tomorrow, description: 'This is a sample event.', user: user)
            expect(event).not_to be_valid
        end

        it 'is not valid if the name contains invalid characters' do
            event = Event.new(name: 'Invalid@Name!', date: Date.tomorrow, description: 'This is a sample event.', user: user)
            expect(event).not_to be_valid
        end

        it 'is not valid without a date' do
            event = Event.new(name: 'Sample Event', date: nil, description: 'This is a sample event.', user: user)
            expect(event).not_to be_valid
        end

        it "is not valid if the date is more than 7 days in the past" do
            event = Event.new(name: "Sample Event", date: Date.today - 8.days, description: "This is a sample event.", user_id: user.id)
            expect(event).not_to be_valid
        end

        it 'is not valid without a description' do
            event = Event.new(name: 'Sample Event', date: Date.tomorrow, description: nil, user: user)
            expect(event).not_to be_valid
        end

        it 'is not valid with a description longer than 500 characters' do
            event = Event.new(name: 'Sample Event', date: Date.tomorrow, description: 'a' * 501, user: user)
            expect(event).not_to be_valid
        end
    end

    describe 'callbacks' do
        it 'normalizes the name before validation' do
            event = Event.create(name: "   Sample Event   ", date: Date.tomorrow, description: "Valid description", user: user)
            expect(event.name).to eq("Sample Event")
        end

        it 'adjusts the event date before saving' do
            event = Event.create(name: "Sample Event", date: Date.tomorrow.change(hour: 10), description: "Valid description", user: user)
            expect(event.date).to eq(Date.tomorrow.beginning_of_day)  # Verifica que la fecha se haya ajustado al inicio del día
        end

    end

    describe '.added_in_last_30_days' do
        it 'returns events created in the last 30 days' do
            recent_event = Event.create(name: "Recent Event", date: Date.tomorrow, description: "Recent description", user: user)
            old_event = Event.create(name: "Old Event", date: Date.current - 31.days, description: "Old description", user: user)
            expect(Event.added_in_last_30_days).to include(recent_event)
            expect(Event.added_in_last_30_days).not_to include(old_event)
        end
    end

    describe '.in_next_week' do
        it 'returns events scheduled for the next week' do
            upcoming_event = Event.create(name: "Upcoming Event", date: Date.current + 5.days, description: "Upcoming description", user: user)
            past_event = Event.create(name: "Past Event", date: Date.yesterday, description: "Past description", user: user)

            expect(Event.in_next_week).to include(upcoming_event)
            expect(Event.in_next_week).not_to include(past_event)
        end
    end
end
