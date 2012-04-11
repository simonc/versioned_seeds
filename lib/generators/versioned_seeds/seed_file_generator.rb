require 'generators/rails/seed_file_generator'

module VersionedSeeds
  class SeedFileGenerator < ::Rails::Generators::SeedFileGenerator
    source_root File.expand_path('../../templates', __FILE__)

    def say_deprecated
      say "====> This generator is now DEPRECATED. <====", :red
      say "Please use:"
      say "  rails g seed_file #{name}"
    end
  end
end
