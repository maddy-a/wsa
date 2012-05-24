class AddCountryToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :country, :string, :default => "India"
  end

  def self.down
    remove_column :users, :country
  end
end
