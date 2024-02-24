#!/opt/puppetlabs/puppet/bin/ruby
require 'yaml'

# This script converts a v3 config file to a v4 config file
# Kindly generated with the help of bots
# It's not perfect, as it doesn't handle all the cases where some data might be 
# missing, but it should be good enough to convert all the existing data
# in the official tinydata module (and in custom tinydata modules)

# Get the file path from the command line argument
file_path = ARGV[0]

# Get the name of the file to write to from the second command line argument
# If no file name is provided, the original file will be overwritten
output_file_path = ARGV[1] || "#{file_path}"

# Load the original yaml file
original_config = YAML.load_file(file_path)

new_config = {}

# Get the key name that contains settings
settings_key = original_config.keys.select { |key| key.end_with?('::settings') }.first

# Package
package_name = original_config[settings_key]['package_name'] if original_config.dig(settings_key, 'package_name')
package_provider = original_config[settings_key]['package_provider'] if original_config.dig(settings_key, 'package_provider')
package_source = original_config[settings_key]['package_source'] if original_config.dig(settings_key, 'package_source')
brew_package_name = original_config[settings_key]['brew_package_name'] if original_config.dig(settings_key, 'brew_package_name')
winget_package_name = original_config[settings_key]['winget_package_name'] if original_config.dig(settings_key, 'winget_package_name')
choco_package_name = original_config[settings_key]['choco_package_name'] if original_config.dig(settings_key, 'choco_package_name')
snap_package_name = original_config[settings_key]['snap_package_name'] if original_config.dig(settings_key, 'snap_package_name')

new_config["packages"] = { "main"  => {} } if package_name or package_provider or brew_package_name or winget_package_name or choco_package_name or snap_package_name or package_source
new_config["packages"]["main"]["name"] = package_name if package_name
new_config["packages"]["main"]["provider"] = package_provider if package_provider
new_config["packages"]["main"]["source"] = package_source if package_source
new_config["packages"]["main"]["providers"] ||= {} if brew_package_name or winget_package_name or choco_package_name or snap_package_name 
new_config["packages"]["main"]["providers"]["brew"] ||= {} if brew_package_name
new_config["packages"]["main"]["providers"]["brew"]["name"] = brew_package_name if brew_package_name
new_config["packages"]["main"]["providers"]["winget"] ||= {} if winget_package_name
new_config["packages"]["main"]["providers"]["winget"]["name"] = winget_package_name if winget_package_name
new_config["packages"]["main"]["providers"]["choco"] ||= {} if choco_package_name
new_config["packages"]["main"]["providers"]["choco"]["name"] = choco_package_name if choco_package_name 
new_config["packages"]["main"]["providers"]["snap"] ||= {} if snap_package_name
new_config["packages"]["main"]["providers"]["snap"]["name"] = snap_package_name if snap_package_name

# Service
service_name = original_config[settings_key]['service_name'] if original_config.dig(settings_key, 'service_name')
process_name = original_config[settings_key]['process_name'] if original_config.dig(settings_key, 'process_name')
process_extra_name = original_config[settings_key]['process_extra_name']  if original_config.dig(settings_key, 'process_extra_name')
process_user = original_config[settings_key]['process_user'] if original_config.dig(settings_key, 'process_user')
process_group = original_config[settings_key]['process_group'] if original_config.dig(settings_key, 'process_group')
nodaemon_args = original_config[settings_key]['nodaemon_args'] if original_config.dig(settings_key, 'nodaemon_args')

new_config["services"] = { service_name => {} } if service_name or process_name or process_extra_name or process_user or process_group or nodaemon_args
new_config["services"][service_name]["process_name"] = process_name if process_name
new_config["services"][service_name]["process_extra_name"] = process_extra_name if process_extra_name
new_config["services"][service_name]["process_user"] = process_user if process_user
new_config["services"][service_name]["process_group"] = process_user if process_group
new_config["services"][service_name]["nodaemon_args"] = nodaemon_args if nodaemon_args


# Files
config_file_path = original_config[settings_key]['config_file_path']  if original_config.dig(settings_key, 'config_file_path')
config_file_format = original_config[settings_key]['config_file_format'] if original_config.dig(settings_key, 'config_file_format')
log_file_path = original_config[settings_key]['log_file_path'] if original_config.dig(settings_key, 'log_file_path') 
init_file_path = original_config[settings_key]['init_file_path'] if original_config.dig(settings_key, 'init_file_path')
pid_file_path = original_config[settings_key]['pid_file_path'] if original_config.dig(settings_key, 'pid_file_path')

new_config["files"] ||= {} if config_file_path or config_file_format or log_file_path or init_file_path or pid_file_path

new_config["files"] = {"config" => {"path" => config_file_path}} if config_file_path
new_config["user_files"] = {"config" => {"path" => config_file_path.gsub('/etc/','$HOME/.') }} if config_file_path

new_config["files"]["config"] ||= {} if config_file_format
new_config["files"]["config"]["format"] = config_file_format if config_file_format

new_config["files"]["log"] ||= {} if log_file_path
new_config["files"]["log"] = { "path" => log_file_path } if log_file_path

new_config["files"]["init"] ||= {} if init_file_path
new_config["files"]["init"] = { "path" => init_file_path } if init_file_path

new_config["files"]["pid"] ||= {} if pid_file_path
new_config["files"]["pid"] = { "path" => pid_file_path } if pid_file_path

# Dirs
config_dir_path = original_config[settings_key]['config_dir_path'] if original_config.dig(settings_key, 'config_dir_path')
new_config["dirs"] = {"config" => {"path" => config_dir_path}} if config_dir_path
new_config["user_dirs"] = {"config" => {"path" => config_dir_path.gsub('/etc/','$HOME/.') }} if config_dir_path
# Get the conf_dir_path from the original config
conf_dir_path = original_config[settings_key]['conf_dir_path'] if original_config.dig(settings_key, 'conf_dir_path')
new_config["dirs"] ||= {} if conf_dir_path
new_config["dirs"]["conf"] = {"path" => conf_dir_path} if conf_dir_path
# Get the log_dir_path from the original config
log_dir_path = original_config[settings_key]['log_dir_path'] if original_config.dig(settings_key, 'log_dir_path')
new_config["dirs"] ||= {} if log_dir_path
new_config["dirs"]["log"] = {"path" => log_dir_path} if log_dir_path
# Get the home_dir_path from the original config
home_dir_path = original_config[settings_key]['home_dir_path'] if original_config.dig(settings_key, 'home_dir_path')
new_config["dirs"] ||= {} if home_dir_path
new_config["dirs"]["home"] = {"path" => home_dir_path} if home_dir_path
# Get the data_dir_path from the original config
data_dir_path = original_config[settings_key]['data_dir_path'] if original_config.dig(settings_key, 'data_dir_path')
new_config["dirs"] ||= {} if data_dir_path
new_config["dirs"]["data"] = {"path" => data_dir_path} if data_dir_path
# Get the ssl_dir_path from the original config
ssl_dir_path = original_config[settings_key]['ssl_dir_path'] if original_config.dig(settings_key, 'ssl_dir_path')
new_config["dirs"] ||= {} if ssl_dir_path
new_config["dirs"]["ssl"] = {"path" => ssl_dir_path} if ssl_dir_path

# Ports
tcp_port = original_config[settings_key]['tcp_port'] if original_config.dig(settings_key, 'tcp_port')
new_config["ports"] ||= {} if tcp_port
new_config["ports"]["main"] = {"port" => tcp_port , "protocol" => "tcp" } if tcp_port
# Get the udp port from the original config
udp_port = original_config[settings_key]['udp_port'] if original_config.dig(settings_key, 'udp_port')
new_config["ports"] ||= {} if udp_port
new_config["ports"]["main_udp"] = {"port" => udp_port , "protocol" => "udp" } if udp_port

# Urls
website_url = original_config[settings_key]['website_url'] if original_config.dig(settings_key, 'website_url')
new_config["urls"] = {"website" => website_url } if website_url
# Get the git_source from the original config
git_source = original_config[settings_key]['git_source'] if original_config.dig(settings_key, 'git_source')
new_config["urls"] ||= {} if git_source
new_config["urls"]["source"] = git_source if git_source

# Get the docker_image from the original config
docker_image = original_config[settings_key]['docker_image'] if original_config.dig(settings_key, 'docker_image')
dockerfile_prerequisites = original_config[settings_key]['dockerfile_prerequisites'] if original_config.dig(settings_key, 'dockerfile_prerequisites')

new_config["image"] ||= {} if docker_image or dockerfile_prerequisites
new_config["image"]["name"] = docker_image if docker_image
new_config["image"]["dockerfile_prerequisites"] = dockerfile_prerequisites if dockerfile_prerequisites

# Repo
upstream_repo = original_config[settings_key]['upstream_repo'] if original_config.dig(settings_key, 'upstream_repo')
new_config["repo"] = 'upstream' if upstream_repo == true


repo_url = original_config[settings_key]['repo_url'] if original_config.dig(settings_key, 'repo_url')
repo_package_name = original_config[settings_key]['repo_package_name'] if original_config.dig(settings_key, 'repo_package_name')
repo_package_url = original_config[settings_key]['repo_package_url'] if original_config.dig(settings_key, 'repo_package_url')
repo_package_provider = original_config[settings_key]['repo_package_provider'] if original_config.dig(settings_key, 'repo_package_provider')
repo_package_params = original_config[settings_key]['repo_package_params'] if original_config.dig(settings_key, 'repo_package_params')
repo_file_url = original_config[settings_key]['repo_file_url'] if original_config.dig(settings_key, 'repo_file_url')
repo_url = original_config[settings_key]['repo_url'] if original_config.dig(settings_key, 'repo_url')
repo_name = original_config[settings_key]['repo_name'] if original_config.dig(settings_key, 'repo_name')
repo_description = original_config[settings_key]['repo_description'] if original_config.dig(settings_key, 'repo_description')
repo_filename = original_config[settings_key]['repo_filename'] if original_config.dig(settings_key, 'repo_filename')
key = original_config[settings_key]['key'] if original_config.dig(settings_key, 'key')
key_url = original_config[settings_key]['key_url'] if original_config.dig(settings_key, 'key_url')
include_src = original_config[settings_key]['include_src'] if original_config.dig(settings_key, 'include_src')
yumrepo_params = original_config[settings_key]['yumrepo_params'] if original_config.dig(settings_key, 'yumrepo_params')

apt_repos = original_config[settings_key]['apt_repos'] if original_config.dig(settings_key, 'apt_repos')
apt_key_server = original_config[settings_key]['apt_key_server'] if original_config.dig(settings_key, 'apt_key_server')
apt_key_fingerprint = original_config[settings_key]['apt_key_fingerprint'] if original_config.dig(settings_key, 'apt_key_fingerprint')
apt_release = original_config[settings_key]['apt_release'] if original_config.dig(settings_key, 'apt_release')
apt_pin = original_config[settings_key]['apt_pin'] if original_config.dig(settings_key, 'apt_pin')
yum_priority = original_config[settings_key]['yum_priority'] if original_config.dig(settings_key, 'yum_priority')
yum_mirrorlist = original_config[settings_key]['yum_mirrorlist'] if original_config.dig(settings_key, 'yum_mirrorlist')
zypper_repofile_url = original_config[settings_key]['zypper_repofile_url'] if original_config.dig(settings_key, 'zypper_repofile_url')
brew_tap = original_config[settings_key]['brew_tap'] if original_config.dig(settings_key, 'brew_tap')

new_config["repo"] ||= { "upstream" => {}} if repo_url or repo_package_name or repo_package_url or repo_package_provider or repo_package_params or repo_file_url or repo_url or repo_name or repo_description or repo_filename or key or key_url or include_src or yumrepo_params or apt_repos or apt_key_server or apt_key_fingerprint or apt_release or apt_pin or yum_priority or yum_mirrorlist or zypper_repofile_url or brew_tap
new_config["repo"]["upstream"]["package_name"] = repo_package_name if repo_package_name
new_config["repo"]["upstream"]["package_url"] = repo_package_url if repo_package_url
new_config["repo"]["upstream"]["package_provider"] = repo_package_provider if repo_package_provider
new_config["repo"]["upstream"]["package_params"] = repo_package_params if repo_package_params
new_config["repo"]["upstream"]["repofile_url"] = repo_file_url if repo_file_url
new_config["repo"]["upstream"]["url"] = repo_url if repo_url
new_config["repo"]["upstream"]["name"] = repo_name if repo_name
new_config["repo"]["upstream"]["description"] = repo_description if repo_description
new_config["repo"]["upstream"]["repofile_name"] = repo_filename if repo_filename
new_config["repo"]["upstream"]["key"] = key if key
new_config["repo"]["upstream"]["key_url"] = key_url if key_url

new_config["repo"]["upstream"]["yum"] ||= {} if yumrepo_params or yum_priority or yum_mirrorlist or key
new_config["repo"]["upstream"]["yum"]["gpgcheck"] = true if key
#new_config["repo"]["upstream"]["yum"]["gpgkey"] = key if key
new_config["repo"]["upstream"]["yum"]["params"] = yumrepo_params if yumrepo_params
new_config["repo"]["upstream"]["yum"]["priority"] = yum_priority if yum_priority
new_config["repo"]["upstream"]["yum"]["mirrorlist"] = yum_mirrorlist if yum_mirrorlist

new_config["repo"]["upstream"]["apt"] ||= {} if include_src or apt_key_server or apt_key_fingerprint or apt_release or apt_pin
new_config["repo"]["upstream"]["apt"]["include_src"] = include_src if include_src
new_config["repo"]["upstream"]["apt"]["key_server"] = apt_key_server if apt_key_server
new_config["repo"]["upstream"]["apt"]["key_fingerprint"] = apt_key_fingerprint if apt_key_fingerprint
new_config["repo"]["upstream"]["apt"]["release"] = apt_release if apt_release
new_config["repo"]["upstream"]["apt"]["pin"] = apt_pin if apt_pin

new_config["repo"]["upstream"]["zypper_repofile_url"] = zypper_repofile_url if zypper_repofile_url
new_config["repo"]["upstream"]["brew_tap"] = brew_tap if brew_tap


# Convert prerequisites
tp_prerequisites = original_config[settings_key]['tp_prerequisites'] if original_config.dig(settings_key, 'tp_prerequisites')
new_config["preinstall"] ||= {} if tp_prerequisites
new_config["preinstall"]['tp::install'] = tp_prerequisites if tp_prerequisites
exec_prerequisites = original_config[settings_key]['exec_prerequisites'] if original_config.dig(settings_key, 'exec_prerequisites')
new_config["preinstall"] ||= {} if exec_prerequisites
new_config["preinstall"]['exec'] = exec_prerequisites if exec_prerequisites
package_prerequisites = original_config[settings_key]['package_prerequisites'] if original_config.dig(settings_key, 'package_prerequisites')
new_config["preinstall"] ||= {} if package_prerequisites
new_config["preinstall"]['package'] = package_prerequisites if package_prerequisites

# Convert postinstall
exec_postinstall = original_config[settings_key]['exec_postinstall'] if original_config.dig(settings_key, 'exec_postinstall') 
new_config["postinstall"] = { 'exec' => exec_postinstall } if exec_postinstall
extra_postinstall = original_config[settings_key]['extra_postinstall'] if original_config.dig(settings_key, 'extra_postinstall')  
new_config["postinstall"] = { 'extra' => extra_postinstall } if extra_postinstall


# Convert the config to a hash
original_output = original_config.to_hash
new_output = new_config.to_hash.to_yaml

new_output.gsub!(/^---\n/, '')
new_output.gsub!(/^/, '  ')    

# Write the merged config to output file
# File.open(output_file_path, 'w') { |file| file.write(original_output.to_yaml) }
if new_config != {}
  File.open(output_file_path, 'a') { |file| file.write("\n# Version 4 format\n") }
  File.open(output_file_path, 'a') { |file| file.write(new_output) }
else
  File.open(output_file_path, 'a') { |file| file.write("\n# No data to convert to Version 4 format\n") }
end
