class CreateFacts < ActiveRecord::Migration
  def change
    create_table :facts do |t|
      t.integer :position
      t.integer :fact_type
      t.string :title
      t.text :description
      t.integer :location_id
      t.datetime :validated_at
      t.integer :rec_area_id
      t.string :state_name
      t.string :location_title
      t.text :location_description
      t.decimal :lat
      t.decimal :lng
      t.timestamps
    end
  end
end
