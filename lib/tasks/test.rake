namespace :test do
    unless Rails.env == 'production'
        require 'rspec/core/rake_task'
        require 'rubocop/rake_task'

        desc 'Execute Rspec'
        RSpec::Core::RakeTask.new(:rspec) do |tsk|
            tsk.rspec_opts = '--format p'
        end

        desc 'Execute cucumber'
        task cucumber: :environment do
            puts 'Cucumber'
            puts `cucumber`
        end

        desc 'Execute rubocop'
        task rubocop: :environment do
            puts 'Rubocop'
            puts `rubocop`
        end
    end
end

task :test do
    %w[rspec cucumber rubocop].each { |task| Rake::Task["test:#{task}"].invoke }
end
