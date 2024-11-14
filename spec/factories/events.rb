FactoryBot.define do
    factory :event do
        name { "Sample Event" }
        date { Date.tomorrow }
        description { "This is a sample event description." }
        association :user  # Esto crea un evento asociado a un usuario automáticamente
    end
end