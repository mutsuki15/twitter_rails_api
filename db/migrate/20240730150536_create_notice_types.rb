class CreateNoticeTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :notice_types do |t|
      t.string :notice_name

      t.timestamps
    end
  end
end