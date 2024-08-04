class AddNotiseTypeToComment < ActiveRecord::Migration[7.0]
  def change
    change_table :comments do |t|
      t.references :notice_type
    end
  end
end