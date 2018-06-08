# !/usr/bin/env ruby -wU
$VERBOSE = nil
require 'yaml'
require 'trollop'

opts = Trollop::options do
  banner <<-EOS
Usage:
       ruby compile.rb -k <keyConfigFile>
EOS
  opt :key_config, 'Config file for signing.', type: :string, default: 'config.yaml', short: '-k'
end

config = YAML.load_file(opts[:key_config])

key_store = config['key_store']

output_file = 'app/build/outputs/apk/release/app-release.apk'

`rm #{output_file}` if File.exists?output_file

puts "Building application..."
puts `#{File.dirname(__FILE__)}/../gradlew assembleRelease --stacktrace \
		-PAPP_RELEASE_STORE_FILE=#{key_store['key']} \
		-PAPP_RELEASE_KEY_ALIAS=#{key_store['alias']} \
		-PAPP_RELEASE_STORE_PASSWORD='#{key_store['store_password']}' \
		-PAPP_RELEASE_KEY_PASSWORD='#{key_store['key_password']}'`

if File.exists?output_file
	puts "New apk successfully build. Path: #{output_file}"
else
	puts "Couldn't build the application."
end