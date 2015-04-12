class AddPhotoUrlToFacts < ActiveRecord::Migration
  def change
    add_column :facts, :pic_url, :string
  end
end
