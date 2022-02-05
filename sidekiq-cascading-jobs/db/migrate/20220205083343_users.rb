# frozen_string_literal: true

class Users < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.datetime :created_at, null: false
    end
  end
end
