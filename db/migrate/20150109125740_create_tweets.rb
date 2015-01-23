class CreateTweets < ActiveRecord::Migration
  def up
    create_table :tweets do |t|
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end

  def down
    drop_table :tweets
  end
end
