require 'rails'
require 'ostruct'
require 'versioned_seeds'

$:.unshift File.join(File.dirname(__FILE__), 'rails_root', 'db', 'seeds')

module VersionedSeeds
  class Tester
    include ClassMethods
  end

  describe Tester do
    def remove_seed_file
      seed_file = Rails.root + '.versioned_seeds'
      File.delete(seed_file) if File.exists?(seed_file)
      seed_file
    end

    let(:rails_root) { Pathname.new(File.dirname __FILE__) + 'rails_root' }
    let(:vs_folder) { rails_root + 'db/seeds' }
    [1,2,3].each do |n|
      let("file#{n}".to_sym) do
        OpenStruct.new file: (vs_folder+"2011120300000#{n}_file#{n}.rb").to_s, version: "2011120300000#{n}"
      end
    end
    let(:seed_files) { [ file1, file2, file3 ] }

    before :each do
      @tester = Tester.new
      @tester.stub(:puts)
      @tester.stub(:require)

      ::Rails.stub(:root) { rails_root }
    end

    context do
      before do
        @tester.stub(:seeds).and_return(seed_files)
        @tester.stub(:load)
      end

      describe 'next' do
        it "should load the next seeding script" do
          @tester.should_receive(:load).with(file2)
          @tester.next([file1.version])
        end
      end

      describe 'all' do
        it "should load all the seeding scripts that haven't been loaded yet" do
          @tester.should_receive(:load).with([file2, file3])
          @tester.all([file1.version])
        end
      end

      describe 'next_seed' do
        it "should return the next seeding script to load" do
          @tester.next_seed([file1.version]).should == file2
        end
      end

      describe 'all_seeds' do
        it "should return all the seeding scripts to load" do
          @tester.all_seeds([file1.version]).should == [file2, file3]
        end
      end

      describe 'last_loaded' do
        it "should return the last loaded seeding script" do
          @tester.last_loaded(seed_files).should == file3
        end
      end
    end

    describe 'load' do
      before do
        @tester.stub(:write_loaded)
      end

      it "should print the name of loaded files" do
        @tester.should_receive(:puts).with("Loading: #{File.basename file1.file}")
        @tester.load file1
      end

      it "should require the seeding scripts" do
        @tester.should_receive(:require).with(file1.file)
        @tester.load file1
      end

      it "should only require the specified seeding scripts" do
        @tester.should_not_receive(:require).with(file1.file)
        @tester.load file2
      end

      it "should be able to require multiple scripts" do
        @tester.should_receive(:require).with(file1.file)
        @tester.should_receive(:require).with(file2.file)
        @tester.load [file1, file2]
      end

      it "should write the loaded scripts to .versioned_file" do
        @tester.should_receive(:write_loaded)
        @tester.load file1
      end
    end

    describe 'seeds' do
      it "should return the files located in the rails_root/db/seeds folder sorted by version" do
        @tester.seeds.should == seed_files
      end
    end

    describe 'write_loaded' do
      it "should write the versions of the loaded script to the versioned_seeds file" do
        seed_file = remove_seed_file
        file = mock('file')
        File.should_receive(:open).with(seed_file, 'a').and_yield(file)
        file.should_receive(:puts).with(file1.version.to_s)
        @tester.write_loaded [file1]
      end
    end

    describe 'already_loaded' do
      it "should return [0] if the file does not exist" do
        remove_seed_file
        @tester.already_loaded.should == [0]
      end

      it "should return the list of already loaded scripts" do
        File.open(Rails.root + '.versioned_seeds', 'w') do |f|
          3.times { |n| f.puts "2011120300000#{n+1}" }
        end
        @tester.already_loaded.should == %w(20111203000001 20111203000002 20111203000003)
      end
    end

  end
end
