class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :parent_tweet, foreign_key: { to_table: :tweets }
      t.references :comment_tweet, foreign_key: { to_table: :tweets }

      t.timestamps
    end
  end
end