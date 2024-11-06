# Event System

The Event System is a Ruby on Rails application designed to manage events. It allows you to create, store, and retrieve events with attributes such as name, date, and description. Additionally, the system includes features like custom scopes for filtering events by date ranges and callbacks to manage event data more effectively.

This README provides step-by-step instructions to set up the application, configure the necessary gems and environment variables, and use custom scopes and callbacks to enrich the functionality of the app.


Setup Instructions
Follow the steps below to set up and run the Event System on your local machine.

1. Create a New Rails Application
Open your terminal and run the following command to create a new Rails application with PostgreSQL as the database:

```bash
rails new event-system --database=postgresql
```
This will create a new Rails application named event-system and configure it to use PostgreSQL as the database.

2. Add the dotenv Gem
To manage environment variables, we will use the dotenv gem. This will allow us to securely store sensitive information such as database credentials.

Open the Gemfile and add the following line:
ruby
```bash
gem 'dotenv-rails'
```

Run the following command to install the gem:
```bash
bundle install
```

3. Set Up Environment Variables
Create a .env file in the root directory of the project:
```bash
touch .env
```
Add your PostgreSQL database credentials (or any other sensitive information) in the .env file. For example:
```bash
DATABASE_USERNAME=your_db_username
DATABASE_PASSWORD=your_db_password
```


4. Configure Database Settings
Now, update the config/database.yml file to use the environment variables you just added. Replace the database username and password with the following:

```bash
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5
  username: <%= ENV['DATABASE_USERNAME'] %>
  password: <%= ENV['DATABASE_PASSWORD'] %>

development:
  <<: *default
  database: event_system_development

test:
  <<: *default
  database: event_system_test

production:
  <<: *default
  database: event_system_production
  username: <%= ENV['DATABASE_USERNAME'] %>
  password: <%= ENV['DATABASE_PASSWORD'] %>

```
5. Create the Database
Run the following command to create the database:

```bash
rake db:create
```

6. Generate the Event Scaffold
To generate the Event model, controller, and views, run the following command:

```bash
rails generate scaffold Event name:string date:date description:text
```
This will create all the necessary files for the Event resource, including migration files, model, controller, and views.

7. Run Migrations
Apply the generated migration to create the events table in the database:

```bash
rake db:migrate
```

8. Set the Root Path
To configure the root of the application to display the events page, edit the config/routes.rb file and set the root route as follows:

```bash
root 'events#index'
```

9. Add Custom Scopes in the Model
In the Event model (app/models/event.rb), add custom scopes to filter events based on specific date ranges. For example, to get events created in the last 30 days:

10. Implement Callbacks for Custom Functionality
Add custom callbacks in the Event model to handle specific logic. For example, you can add a before_save callback to adjust the event date before saving the record:

11. Create a Controller Object with Scopes
In the EventsController, create a controller action to use the defined scopes and send the filtered events to the view:

12. Consume the Scopes in the View
In the app/views/events/index.html.erb file, display the filtered events.

