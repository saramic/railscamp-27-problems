# frozen_string_literal: true

require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { db: 1 }
end

# a worker class to demo cascading jobs
class WorkerDemo
  include Sidekiq::Worker

  def perform(name)
    sleep 1
    puts name
  end
end
