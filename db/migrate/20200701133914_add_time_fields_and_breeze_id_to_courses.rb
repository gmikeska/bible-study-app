class AddTimeFieldsAndBreezeIdToCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :start_date, :date
    add_column :courses, :frequency, :integer
    add_column :courses, :frequency_interval, :string
    add_column :courses, :start_time, :time
    add_column :courses, :end_time, :time
    add_column :courses, :on_calendar?, :boolean
    add_column :courses, :all_day?, :boolean
    add_column :courses, :breeze_calendar_id, :integer
    add_column :courses, :breeze_events, :string
    add_column :courses, :breeze_id, :integer
  end
end
