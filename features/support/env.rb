FEATURES_PATH = File.expand_path('../..', __FILE__)

# load shared env with features
require File.expand_path('../../../../spree/features/support/env', __FILE__)

# load the rest of files for support and step definitions
directories = [ File.expand_path('../../../../spree/features/support', __FILE__),
                File.expand_path('../../../../spree/features/step_definitions', __FILE__),
                File.expand_path('../../../spec/factories', __FILE__) ]

files = directories.map do |dir|
  Dir["#{dir}/**/*.rb"]
end.flatten.uniq

files.each do |path|
  if path !~ /env.rb$/
    fp = File.expand_path(path)
    #puts fp
    load(fp)
  end
end

