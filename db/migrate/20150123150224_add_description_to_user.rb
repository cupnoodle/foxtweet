class AddDescriptionToUser < ActiveRecord::Migration
  def up
    add_column "users", "description", :string, :after => :email
  end

  def down
    remove_column "users", "description"
  end
end
