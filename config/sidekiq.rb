# This block configures the Sidekiq server when it starts up.
Sidekiq.configure_server do |config|

    # Adds a hook that will be executed when the Sidekiq server starts.
    config.on(:startup) do
  
      # Loads the schedule configuration from a YAML file.
      # The schedule file typically defines recurring jobs and their execution times.
      # The path '../../sidekiq_schedule.yml' points to the schedule file in the app's directory structure.
      Sidekiq.schedule = YAML.load_file(File.expand_path('../../sidekiq_schedule.yml', __FILE__))
  
      # Reloads the job schedule into Sidekiq's scheduler.
      # This ensures that the recurring jobs defined in the schedule file are recognized and executed.
      Sidekiq::Scheduler.reload_schedule!
      
    end
end
  