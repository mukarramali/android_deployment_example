# !/usr/bin/env ruby -wU
$VERBOSE = nil
require 'yaml'
require 'io/console'
require 'trollop'
require 'json'

opts = Trollop::options do
  banner <<-EOS
Usage:
       ruby deploy.rb -s <s3ConfigFile> [options]
EOS
  opt :s3_config, 's3 config file.', type: :string, short: '-s'
  opt :app_name, 'App name', type: :string, default: 'dallas_offline', short: '-a'
  opt :bucket, 'Bucket name', type: :string, short: '-b'
  opt :tag, 'Push with a new version tag', type: :boolean, default: true, short: '-t'
end

output_file = JSON.parse(File.read(File.join('app', 'build', 'outputs', 'apk', 'release', 'output.json')))[0]
version_name = output_file['apkInfo']['versionName']
version_code = output_file['apkInfo']['versionCode']

app_name = opts[:app_name]
bucket = opts[:bucket] || "#{app_name}-apk"

s3_config = opts[:s3_config] || `$HOME/.s3cfg`

def push_new_tag version_name
	`git tag #{version_name}`
	`git push origin #{version_name}`
	puts "New tag pushed to repo."
end

if File.file?(s3_config)
	`s3cmd put app/build/outputs/apk/release/app-release.apk s3://#{bucket}/#{app_name}-#{version_name}.apk -m application/vnd.android.package-archive -f -P -c #{opts[:s3_config]}`
	`s3cmd put app/build/outputs/apk/release/app-release.apk s3://#{bucket}/#{app_name}.apk -m application/vnd.android.package-archive -f -P -c #{opts[:s3_config]}`
	`echo #{version_code}> latest_version.txt`
	`s3cmd put latest_version.txt s3://#{bucket}/latest_version.txt -f -P -c #{opts[:s3_config]}`
	`rm latest_version.txt`
	puts "Successfully released new app version."
	push_new_tag version_name if opts[:tag]
end
