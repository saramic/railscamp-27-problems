class CreateUsersAndEmailSends < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, index: {unique: true}, null: false
      t.datetime :created_at, null: false
    end

    create_table :email_sends do |t|
      t.references :user, null: false
      t.datetime :created_at, null: false
    end
  end
end
