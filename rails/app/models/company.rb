class Company < ActiveRecord::Base
  attr_accessible :name
  
  # Callbacks
  after_create  :prepare_schema
  after_destroy :drop_schema
  
  # Validations
  validates :name, :presence => true
  validates :subdomain, :presence   => true, 
                        :uniqueness => {:case_sensitive => false}, 
                        :format     => {:with => /^[a-zA-Z0-9][a-zA-Z0-9-]*$/},
                        :exclusion  => {:in => ["www"]}
  
  
  private
  def prepare_schema
    create_schema
    load_tables
  end
  
  def create_schema
    PgTools.create_schema(self.subdomain) unless PgTools.schemas.include?(self.subdomain)
  end
  
  def drop_schema
    PgTools.drop_schema(self.subdomain) if PgTools.schemas.include?(self.subdomain)
  end

  def load_tables
    return if Rails.env.test?
    PgTools.set_search_path(self.subdomain, :without_public => true)
    PgTools.load_rails_schema
    PgTools.restore_default_search_path
  end
  
end
