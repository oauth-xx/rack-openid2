require "kettle/soup/cover/config"

SimpleCov.start do
  track_files "lib/**/*.rb"
  track_files "lib/**/*.rake"
  track_files "exe/*.rb"
  add_filter "test/**/*"
end
