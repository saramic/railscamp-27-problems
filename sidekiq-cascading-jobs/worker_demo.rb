# frozen_string_literal: true

require "sidekiq"
require "active_record"

$LOAD_PATH << File.join(
  File.expand_path(__dir__), "app"
)
require "models/user"

def db_configuration
  db_configuration_file = File.join(
    File.expand_path(__dir__), "db/config.yml"
  )
  YAML.load(File.read(db_configuration_file)) # rubocop:disable Security/YAMLLoad
end

ActiveRecord::Base.establish_connection(
  db_configuration["development"]
)

Sidekiq.options[:concurrency] = 1

Sidekiq.configure_client do |config|
  config.redis = {db: 1}
end

Sidekiq.configure_server do |config|
  config.redis = {db: 1}
end

# a worker class to demo cascading jobs
class WorkerDemo
  include Sidekiq::Worker

  def perform(name)
    User.create!(name: name)
  end
end
