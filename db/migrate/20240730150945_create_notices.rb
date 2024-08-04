class CreateNotices < ActiveRecord::Migration[7.0]
  def change
    create_table :notices do |t|
      t.references :noticed_user, foreign_key: { to_table: :users }
      t.references :notice_user, foreign_key: { to_table: :users }
      t.references :tweet
      t.references :notice_type

      t.timestamps
    end
  end
end