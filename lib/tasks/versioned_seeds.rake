require 'versioned_seeds'

namespace :vs do
  desc "Display current seeds version"
  task :status do
    puts "Last seeds: #{VersionedSeeds.last_loaded}"
  end

  desc "Load the next seeding script"
  task :next => :environment do
    VersionedSeeds.next
  end

  desc "Load the specified seeding script (specify version w/ SEED=012345678901)"
  task :load => :environment do
    version = ENV['SEED']
    VersionedSeeds.load_one(version) if version
  end

  desc "Load all seeding scripts that haven't been loaded yet"
  task :all => :environment do
    VersionedSeeds.all
  end
end
