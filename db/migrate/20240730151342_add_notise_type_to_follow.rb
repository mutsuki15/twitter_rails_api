class AddNotiseTypeToFollow < ActiveRecord::Migration[7.0]
  def change
    change_table :follows do |t|
      t.references :notice_type
    end
  end
end
