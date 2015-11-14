class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :user_id, null: false
      t.integer :submission_id, null: false
      t.text :body, null: false

      t.timestamps null: false
    end
  end
end
