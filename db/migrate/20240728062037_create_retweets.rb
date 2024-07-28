class CreateRetweets < ActiveRecord::Migration[7.0]
  def change
    create_table :retweets do |t|
      t.references :tweet
      t.references :user

      t.timestamps
    end
  end
end