class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.belongs_to :user, foreign_key: {on_delete: :cascade}
      t.integer :activity_type
      t.date :activity_date
      t.integer :duration

      t.timestamps
    end
  end
end
