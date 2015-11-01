class UpdateRequirementsOnSubmissions < ActiveRecord::Migration
  def change
    remove_column :submissions, :integer, :integer
    change_column :submissions, :day, :datetime, null: true
  end
end
