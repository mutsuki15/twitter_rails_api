class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.references :tweet
      t.references :user

      t.timestamps
    end
  end
end