class AddTicketsResponseToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :tickets_quantity, :integer
    add_column :events, :capacity, :integer
  end
end
