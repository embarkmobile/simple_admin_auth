require "bundler/gem_tasks"

task :update_gemfiles do
  puts "Run all of the following:"
  puts "bundle install"
  Dir['gemfiles/*.gemfile'].each do |gemfile|
    puts "BUNDLE_GEMFILE=#{gemfile} bundle install"
  end
end
