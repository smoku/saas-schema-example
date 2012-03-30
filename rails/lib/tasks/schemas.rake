namespace :schemas do
  namespace :db do
    desc "runs db:migrate on each company's private schema"
    task :migrate => :environment do
      verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      ActiveRecord::Migration.verbose = verbose

      Company.all.each do |company|
        puts "Migrating company #{company.name} (#{company.subdomain}) ID:#{company.id}"
        PgTools.set_search_path(company.subdomain, :without_public => true)
        version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
        ActiveRecord::Migrator.migrate("db/migrate/", version)
      end
    end
  end
end