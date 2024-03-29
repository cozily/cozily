rspec_gem_dir = nil
Dir["#{Rails.root.to_s}/vendor/gems/*"].each do |subdir|
  rspec_gem_dir = subdir if subdir.gsub("#{Rails.root.to_s}/vendor/gems/","") =~ /^(\w+-)?rspec-(\d+)/ && File.exist?("#{subdir}/lib/spec/rake/spectask.rb")
end
rspec_plugin_dir = File.expand_path(File.dirname(__FILE__) + '/../../vendor/plugins/rspec')

if rspec_gem_dir && (test ?d, rspec_plugin_dir)
  raise "\n#{'*'*50}\nYou have rspec installed in both vendor/gems and vendor/plugins\nPlease pick one and dispose of the other.\n#{'*'*50}\n\n"
end

if rspec_gem_dir
  $LOAD_PATH.unshift("#{rspec_gem_dir}/lib")
elsif File.exist?(rspec_plugin_dir)
  $LOAD_PATH.unshift("#{rspec_plugin_dir}/lib")
end

# Don't load rspec if running "rake gems:*"
unless ARGV.any? {|a| a =~ /^gems/}

begin
  require 'spec/rake/spectask'
rescue MissingSourceFile
  module Spec
    module Rake
      class SpecTask
        def initialize(name)
          task name do
            # if rspec-rails is a configured gem, this will output helpful material and exit ...
            require File.expand_path(File.join(File.dirname(__FILE__),"..","..","config","environment"))
          end
        end
      end
    end
  end
end

Rake.application.instance_variable_get('@tasks').delete('default')

spec_prereq = File.exist?(File.join(Rails.root.to_s, 'config', 'database.yml')) ? "db:test:prepare" : :noop
task :noop do
end

task :default => :spec
task :stats => "spec:statsetup"

desc "Run all specs in spec directory (excluding plugin specs)"
Spec::Rake::SpecTask.new(:spec => spec_prereq) do |t|
  t.spec_opts = ['--options', "\"#{Rails.root.to_s}/spec/spec.opts\""]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

namespace :spec do
  desc "Run all specs in spec directory with RCov (excluding plugin specs)"
  Spec::Rake::SpecTask.new(:rcov) do |t|
    t.spec_opts = ['--options', "\"#{Rails.root.to_s}/spec/spec.opts\""]
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.rcov = true
    t.rcov_opts = lambda do
      IO.readlines("#{Rails.root.to_s}/spec/rcov.opts").map {|l| l.chomp.split " "}.flatten
    end
  end

  desc "Print Specdoc for all specs (excluding plugin specs)"
  Spec::Rake::SpecTask.new(:doc) do |t|
    t.spec_opts = ["--format", "specdoc", "--dry-run"]
    t.spec_files = FileList['spec/**/*_spec.rb']
  end

  desc "Print Specdoc for all plugin examples"
  Spec::Rake::SpecTask.new(:plugin_doc) do |t|
    t.spec_opts = ["--format", "specdoc", "--dry-run"]
    t.spec_files = FileList['vendor/plugins/**/spec/**/*_spec.rb'].exclude('vendor/plugins/rspec/*')
  end

  [:models, :controllers, :views, :helpers, :lib, :integration].each do |sub|
    desc "Run the code examples in spec/#{sub}"
    Spec::Rake::SpecTask.new(sub => spec_prereq) do |t|
      t.spec_opts = ['--options', "\"#{Rails.root.to_s}/spec/spec.opts\""]
      t.spec_files = FileList["spec/#{sub}/**/*_spec.rb"]
    end
  end

  desc "Run the code examples in vendor/plugins (except RSpec's own)"
  Spec::Rake::SpecTask.new(:plugins => spec_prereq) do |t|
    t.spec_opts = ['--options', "\"#{Rails.root.to_s}/spec/spec.opts\""]
    t.spec_files = FileList['vendor/plugins/**/spec/**/*_spec.rb'].exclude('vendor/plugins/rspec/*').exclude("vendor/plugins/rspec-rails/*")
  end

  namespace :plugins do
    desc "Runs the examples for rspec_on_rails"
    Spec::Rake::SpecTask.new(:rspec_on_rails) do |t|
      t.spec_opts = ['--options', "\"#{Rails.root.to_s}/spec/spec.opts\""]
      t.spec_files = FileList['vendor/plugins/rspec-rails/spec/**/*_spec.rb']
    end
  end

  # Setup specs for stats
  task :statsetup do
    require 'code_statistics'
    ::STATS_DIRECTORIES << %w(Model\ specs spec/models) if File.exist?('spec/models')
    ::STATS_DIRECTORIES << %w(View\ specs spec/views) if File.exist?('spec/views')
    ::STATS_DIRECTORIES << %w(Controller\ specs spec/controllers) if File.exist?('spec/controllers')
    ::STATS_DIRECTORIES << %w(Helper\ specs spec/helpers) if File.exist?('spec/helpers')
    ::STATS_DIRECTORIES << %w(Library\ specs spec/lib) if File.exist?('spec/lib')
    ::STATS_DIRECTORIES << %w(Routing\ specs spec/routing) if File.exist?('spec/routing')
    ::STATS_DIRECTORIES << %w(Integration\ specs spec/integration) if File.exist?('spec/integration')
    ::CodeStatistics::TEST_TYPES << "Model specs" if File.exist?('spec/models')
    ::CodeStatistics::TEST_TYPES << "View specs" if File.exist?('spec/views')
    ::CodeStatistics::TEST_TYPES << "Controller specs" if File.exist?('spec/controllers')
    ::CodeStatistics::TEST_TYPES << "Helper specs" if File.exist?('spec/helpers')
    ::CodeStatistics::TEST_TYPES << "Library specs" if File.exist?('spec/lib')
    ::CodeStatistics::TEST_TYPES << "Routing specs" if File.exist?('spec/routing')
    ::CodeStatistics::TEST_TYPES << "Integration specs" if File.exist?('spec/integration')
  end

  namespace :db do
    namespace :fixtures do
      desc "Load fixtures (from spec/fixtures) into the current environment's database.  Load specific fixtures using FIXTURES=x,y. Load from subdirectory in test/fixtures using FIXTURES_DIR=z."
      task :load => :environment do
        ActiveRecord::Base.establish_connection(Rails.env)
        base_dir = File.join(Rails.root, 'spec', 'fixtures')
        fixtures_dir = ENV['FIXTURES_DIR'] ? File.join(base_dir, ENV['FIXTURES_DIR']) : base_dir

        require 'active_record/fixtures'
        (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/).map {|f| File.join(fixtures_dir, f) } : Dir.glob(File.join(fixtures_dir, '*.{yml,csv}'))).each do |fixture_file|
          Fixtures.create_fixtures(File.dirname(fixture_file), File.basename(fixture_file, '.*'))
        end
      end
    end
  end
end

end
