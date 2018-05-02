class CreateFriends < ActiveRecord::Migration[5.1]
  def change
    create_table :friends do |t|
      t.integer :friend_id

      t.timestamps
    end

    add_reference :friends, :user, index: true, foreign_key: {on_delete: :cascade}
  end
end
