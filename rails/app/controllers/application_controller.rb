class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_company_schema
  
  helper_method :current_company
  
  private
  def current_company
    @current_company = Company.find_by_subdomain!(request.subdomain) unless defined?(@current_company)
    @current_company
  end
  
  def set_company_schema
    if PgTools.schemas.include?(current_company.subdomain)
      PgTools.set_search_path(current_company.subdomain)
    else
      raise ActiveRecord::RecordNotFound # raise 404
    end
  end

end
