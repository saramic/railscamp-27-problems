# frozen_string_literal: true

require "active_record"

$LOAD_PATH << File.join(
  File.expand_path(__dir__)
)
require "models/user"

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
  User
].each do |model|
  pp [model.name, model.count]
end
