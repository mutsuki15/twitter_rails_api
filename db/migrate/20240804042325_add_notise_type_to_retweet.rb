class AddNotiseTypeToRetweet < ActiveRecord::Migration[7.0]
  def change
    change_table :retweets do |t|
      t.references :notice_type
    end
  end
end
