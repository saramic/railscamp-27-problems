# frozen_string_literal: true

require "sidekiq"
require "active_record"

$LOAD_PATH << File.join(
  File.expand_path(__dir__), "app"
)
require "models/user"
require "models/email_send"
require "models/outbox"

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
class WorkerOutbox
  include Sidekiq::Worker

  def perform(outbox_id)
    Outbox.transaction do
      outbox = Outbox.find(outbox_id)
      raise ArgumentException unless outbox.event == "email_send"

      EmailSend.create!(user: outbox.model) 
      outbox.destroy
    end
  end
end

# a worker class to demo cascading jobs
class WorkerDemo
  include Sidekiq::Worker

  def perform(name)
    outbox = nil
    User.transaction do
      user = User.create!(name: name)

      raise ArgumentError if ENV.fetch("SIDEKIQ_MID_TRANSACTION_ERROR", nil)

      outbox = Outbox.create(model: user, event: "email_send")
    end

    raise ArgumentError if ENV.fetch("SIDEKIQ_PRE_JOB_ERROR", nil)

    WorkerOutbox.perform_at(3.seconds.from_now, outbox.id) if outbox
  rescue ActiveRecord::RecordNotUnique => e
    $stdout.puts "RecordNotUnique: #{e.message}"
  end
end
