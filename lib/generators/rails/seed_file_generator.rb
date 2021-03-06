require 'rails/generators'

module Rails
  module Generators
    class SeedFileGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path("../../templates", __FILE__)

      desc "Generates a seed file with a timestamped name"
      def create_seed_file
        template 'seed_file.rb', "db/seeds/#{script_name}.rb"
      end

      private

      def script_name
        ts = Time.now.utc.strftime("%Y%m%d%H%M%S")
        "#{ts}_#{name}"
      end
    end
  end
end
