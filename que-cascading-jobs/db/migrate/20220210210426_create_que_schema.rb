require "que"

class CreateQueSchema < ActiveRecord::Migration[6.1]
  def up
    Que.migrate!(version: 5)
  end

  def down
    Que.migrate!(version: 0)
  end
end
