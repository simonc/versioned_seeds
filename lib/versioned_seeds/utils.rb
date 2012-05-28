module VersionedSeeds
  module Utils
    if defined?(Rails)
      def self.load_sql(path)
        sql_file    = VersionedSeeds.root_path + 'db/seeds/' + path
        db_password = db_config['password']

        system "RAILS_ENV='#{Rails.env}' bundle exec rails dbconsole -p '#{db_password}' < '#{sql_file}'"
      end

      def self.db_config
        @db_config = Rails.application.config.database_configuration[Rails.env]
      end
    end
  end
end
