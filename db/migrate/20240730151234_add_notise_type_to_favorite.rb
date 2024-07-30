class AddNotiseTypeToFavorite < ActiveRecord::Migration[7.0]
  def change
    change_table :favorites do |t|
      t.references :notice_type
    end
  end
end