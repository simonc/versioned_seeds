require "ostruct"
require "versioned_seeds/version"

module VersionedSeeds
  require "versioned_seeds/railtie" if defined?(Rails)

  module ClassMethods # :nodoc:
    # Loads the next seeding script
    def next(loaded=already_loaded)
      load next_seed(loaded)
    end

    # Loads all the seeding scripts that haven't been loaded yet
    def all(loaded=already_loaded)
      load all_seeds(loaded)
    end

    # Returns the next seeding script to load
    def next_seed(loaded=already_loaded)
      all_seeds(loaded).first
    end

    # Returns all the seeding scripts to load
    def all_seeds(loaded=already_loaded)
      seeds.delete_if { |seed| loaded.include?(seed) }
    end

    # returns the last loaded seeding script
    def last_loaded(loaded=already_loaded)
      loaded.last
    end

    # Loads a list of seeding scripts and updates the .versioned_seeds file
    def load(seeds)
      seeds = [*seeds]
      loaded = seeds.inject([]) do |ary, seed|
        puts "Loading: #{File.basename seed.file}"
        require seed.file
        ary << seed
        ary
      end

      write_loaded loaded
    end

    # Returns the files located in the rails_root/db/seeds folder sorted by version
    def seeds
      Dir[Rails.root + 'db/seeds/*.rb'].inject([]) { |list, file|
        filename = File.basename(file)
        version  = filename[/^(\d+)_/, 1]

        next unless version

        list << OpenStruct.new(:file => file, :version => version)
        list
      }.sort { |seed1, seed2| seed1.version <=> seed2.version }
    end

    def write_loaded(loaded)
      if loaded.any?
        File.open(Rails.root + '.versioned_seeds', 'a') do |f|
          loaded.each { |seed| f.puts seed.version }
        end
      else
        puts "No seed has been loaded"
      end
    end

    def already_loaded
      file = Rails.root + '.versioned_seeds'
      return [0] unless File.exists?(file)
      File.read(file).split(/\r?\n/)
    end
  end

  extend ClassMethods
end
