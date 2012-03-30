class CreateCompanies < ActiveRecord::Migration
  def change
    return if PgTools.private_search_path?
    
    create_table :companies do |t|
      t.string :name
      t.string :subdomain
      t.timestamps
    end
  end
end
