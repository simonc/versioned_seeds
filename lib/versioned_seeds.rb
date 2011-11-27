require "ostruct"
require "versioned_seeds/version"

module VersionedSeeds
  require "versioned_seeds/railtie" if defined?(Rails)

  class << self
    def next(version=current_version)
      load next_seeds(version)
    end

    def all(version=current_version)
      load all_seeds(version)
    end

    def load(seeds)
      last_version = seeds.inject(false) do |version, seed|
        puts "Loading: #{File.basename seed.file}"
        require seed.file
        seed.version
      end
      write_version last_version if last_version
    end

    def next_seeds(version=current_version)
      seeds.keep_if { |seed| seed.version == version.next }
    end

    def all_seeds(version=current_version)
      seeds.keep_if { |seed| seed.version > version }
    end

    def seeds
      Dir[Rails.root+'db/seeds/*.rb'].inject([]) { |list, file|
        filename = File.basename(file)
        version  = filename.to_i
        list << OpenStruct.new(:file => file, :version => version)
        list
      }.sort { |seed1, seed2| seed1.version <=> seed2.version }
    end

    def write_version(version)
      File.open(Rails.root+'.versioned_seeds', 'w') do |f|
        f.puts version
      end
    end

    def current_version
      file = Rails.root+'.versioned_seeds'
      return 0 unless File.exists?(file)
      File.read(file).to_i
    end
  end
end
