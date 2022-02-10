require "que"
require "que/web"
require "active_record"

def db_configuration
  db_configuration_file = File.join(
    File.expand_path(__dir__), "db/config.yml"
  )
  YAML.load(File.read(db_configuration_file)) # rubocop:disable Security/YAMLLoad
end

ActiveRecord::Base.establish_connection(
  db_configuration["development"]
)

Que.connection = ActiveRecord

map "/" do
  run Que::Web
end
