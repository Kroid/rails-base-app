class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :authentication_token
      t.string :platform
      t.string :uuid

      t.references :user, index: true, null: false

      t.timestamps null: false
    end
  end
end
