require 'rails'
require 'versioned_seeds'

module VersionedSeeds
  class Railtie < Rails::Railtie
    railtie_name :versioned_seeds

    rake_tasks do
      load "tasks/versioned_seeds.rake"
    end
  end
end
