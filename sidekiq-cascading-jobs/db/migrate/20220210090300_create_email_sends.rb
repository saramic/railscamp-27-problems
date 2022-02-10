class CreateEmailSends < ActiveRecord::Migration[6.1]
  def change
    create_table :email_sends do |t|
      t.references :user, null: false
      t.datetime :created_at, null: false
    end
  end
end
