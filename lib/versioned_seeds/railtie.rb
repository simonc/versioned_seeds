require 'versioned_seeds'
require 'rails'

module VersionedSeeds
  class Railtie < Rails::Railtie
    railtie_name :versioned_seeds

    rake_tasks do
      load "tasks/versioned_seeds.rake"
    end
  end
end
