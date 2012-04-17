require "ostruct"
require "versioned_seeds/version"

module VersionedSeeds
  require "versioned_seeds/railtie" if defined?(Rails)

  module ClassMethods # :nodoc:
    def configure
      yield self
    end

    # Loads seeding script with the given version
    def load_one(version)
      seed = all_seeds([]).select { |seed| seed.version == version }.first
      load seed, false
    end

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
      seeds.delete_if { |seed| loaded.include?(seed.version) }
    end

    # returns the last loaded seeding script
    def last_loaded(loaded=already_loaded)
      loaded.last
    end

    # Loads a list of seeding scripts and updates the .versioned_seeds file
    def load(seeds, write=true)
      [*seeds].each do |seed|
        puts "Loading: #{File.basename seed.file}"
        require seed.file
        write_loaded seed if write
      end
    end

    # Returns the files located in the <root_path>/db/seeds folder sorted by version
    def seeds
      Dir[root_path + 'db/seeds/*.rb'].inject([]) { |list, file|
        filename = File.basename(file)
        version  = filename[/^(\d+)_/, 1]

        next unless version

        list << OpenStruct.new(:file => file, :version => version)
        list
      }.sort { |seed1, seed2| seed1.version <=> seed2.version }
    end

    # Writes the versions of the loaded script to the .versionned_seeds file
    def write_loaded(loaded)
      File.open(root_path + '.versioned_seeds', 'a') do |f|
        f.puts loaded.version
      end
    end

    # Returns the list of already loaded scripts
    def already_loaded
      file = root_path + '.versioned_seeds'
      return [0] unless File.exists?(file)
      File.read(file).split(/\r?\n/)
    end

    def root_path
      @root_path ||= Rails.root if defined?(Rails)
      return @root_path if @root_path
      raise "VersionedSeeds.root_path is not set.\n"      \
            "VersionedSeeds.configure do |config|\n"      \
            "  config.root_path = '/root/of/your/app/'\n" \
            "end"
    end

    def root_path=(path)
      @root_path = path
      @root_path += '/' unless @root_path.nil? || @root_path.end_with?('/')
    end
  end

  extend ClassMethods
end
