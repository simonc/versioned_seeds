require 'versioned_seeds'

namespace :vs do
  desc "Display current seeds version"
  task :status do
    puts "Last seeds: #{VersionedSeeds.current_version}"
  end

  desc "Task description"
  task :next => :environment do
    VersionedSeeds.next
  end

  desc "Task description"
  task :all => :environment do
    VersionedSeeds.all
  end
end
