class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :username, :limit => 32
      t.string :name, :limit => 64
      t.string :email, :limit => 32
      t.string :password_digest
      t.string :avatar_url

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
