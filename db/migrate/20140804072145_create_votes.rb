class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :image
      t.references :user
      t.boolean :up
      t.timestamps
    end
  end
end
