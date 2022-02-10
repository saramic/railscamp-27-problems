# frozen_string_literal: true

require "active_record"

$LOAD_PATH << File.join(
  File.expand_path(__dir__)
)
require "models/user"
require "models/email_send"
require "models/outbox"

def db_configuration
  db_configuration_file = File.join(
    File.expand_path(__dir__), "..", "db", "config.yml"
  )
  YAML.load(File.read(db_configuration_file)) # rubocop:disable Security/YAMLLoad
end

ActiveRecord::Base.establish_connection(
  db_configuration["development"]
)

[
  User,
  EmailSend,
  Outbox,
].each do |model|
  pp [model.name, model.count, model.all]
end
