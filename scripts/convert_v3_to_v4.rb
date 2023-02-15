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
output_file_path = ARGV[1] || file_path

# Load the original yaml file
original_config = YAML.load_file(file_path)

# Get the key name that contains settings
settings_key = original_config.keys.select { |key| key.end_with?('::settings') }.first


# Get the package name from the original config
package_name = original_config[settings_key]['package_name']
original_config[settings_key]["packages"] = {"main" => {"name" => package_name}} if package_name
# Get the package provider from the original config
#package_provider = original_config[settings_key]['package_provider']
#original_config[settings_key]["packages"]["main"]["package_provider"] if package_provider

# Get the service name from the original config
service_name = original_config[settings_key]['service_name']
original_config[settings_key]["services"][service_name] if service_name
# Get the process name from the original config
process_name = original_config[settings_key]['process_name']
original_config[settings_key]["services"][service_name]["process_name"] = process_name if process_name
# Get the process_extra name from the original config
process_extra_name = original_config[settings_key]['process_extra_name']
original_config[settings_key]["services"][service_name]["process_extra_name"] = process_extra_name if process_extra_name
# Get the process user from the original config
process_user = original_config[settings_key]['process_user']
original_config[settings_key]["services"][service_name]["process_user"] = process_user if process_user
# Get the process group from the original config
process_group = original_config[settings_key]['process_group']
original_config[settings_key]["services"][service_name]["process_group"] = process_user if process_group
# Get the process nodaemon_args from the original config
nodaemon_args = original_config[settings_key]['nodaemon_args']
original_config[settings_key]["services"][service_name]["nodaemon_args"] = nodaemon_args if nodaemon_args


# Get the config_file_path from the original config
config_file_path = original_config[settings_key]['config_file_path']
original_config[settings_key]["files"] = {"config" => {"path" => config_file_path}} if config_file_path
original_config[settings_key]["user_files"] = {"config" => {"path" => config_file_path.gsub('/etc/','$HOME/.') }} if config_file_path
# Get the config_file_format from the original config
config_file_format = original_config[settings_key]['config_file_format']
original_config[settings_key]["files"]["config"]["format"] = config_file_format if config_file_format
# Get the log_file_path from the original config
log_file_path = original_config[settings_key]['log_file_path']
original_config[settings_key]["files"]["log"] = {"path" => log_file_path} if log_file_path
# Get the init_file_path from the original config
init_file_path = original_config[settings_key]['init_file_path']
original_config[settings_key]["files"]["init"] = {"path" => init_file_path} if init_file_path

# Get the config_dir_path from the original config
config_dir_path = original_config[settings_key]['config_dir_path']
original_config[settings_key]["dirs"] = {"config" => {"path" => config_dir_path}} if config_dir_path
original_config[settings_key]["user_dirs"] = {"config" => {"path" => config_dir_path.gsub('/etc/','$HOME/.') }} if config_dir_path
# Get the conf_dir_path from the original config
conf_dir_path = original_config[settings_key]['conf_dir_path']
original_config[settings_key]["dirs"]["conf"] = {"path" => conf_dir_path} if conf_dir_path
# Get the log_dir_path from the original config
log_dir_path = original_config[settings_key]['log_dir_path']
original_config[settings_key]["dirs"]["log"] = {"path" => log_dir_path} if log_dir_path
# Get the home_dir_path from the original config
home_dir_path = original_config[settings_key]['home_dir_path']
original_config[settings_key]["dirs"]["home"] = {"path" => home_dir_path} if home_dir_path
# Get the data_dir_path from the original config
data_dir_path = original_config[settings_key]['data_dir_path']
original_config[settings_key]["dirs"]["data"] = {"path" => data_dir_path} if data_dir_path
# Get the ssl_dir_path from the original config
ssl_dir_path = original_config[settings_key]['ssl_dir_path']
original_config[settings_key]["dirs"]["ssl"] = {"path" => ssl_dir_path} if ssl_dir_path

# Get the tcp port from the original config
tcp_port = original_config[settings_key]['tcp_port']
original_config[settings_key]["ports"] = {"main" => {"port" => tcp_port}} if tcp_port
# Get the udp port from the original config
udp_port = original_config[settings_key]['udp_port']
original_config[settings_key]["ports"] = {"main" => {"port" => udp_port}} if udp_port

# Get the website_url from the original config
website_url = original_config[settings_key]['website_url']
original_config[settings_key]["urls"] = {"website" => website_url } if website_url
# Get the git_source from the original config
git_source = original_config[settings_key]['git_source']
original_config[settings_key]["urls"]["source"] = git_source if git_source

# Get the docker_image from the original config
docker_image = original_config[settings_key]['docker_image']
original_config[settings_key]["image"] = {"name" => docker_image } if docker_image
# Get the dockerfile_prerequisites from the original config
dockerfile_prerequisites = original_config[settings_key]['dockerfile_prerequisites']
original_config[settings_key]["image"] = {"dockerfile_prerequisites" => dockerfile_prerequisites } if dockerfile_prerequisites

# Convert upstream_repo to repo = upstream
upstream_repo = original_config[settings_key]['upstream_repo']
original_config[settings_key]["repo"] = 'upstream' if upstream_repo == true

# Convert prerequisites
tp_prerequisites = original_config[settings_key]['tp_prerequisites']
original_config[settings_key]["preinstall"] = { 'tp::install' => tp_prerequisites } if tp_prerequisites
exec_prerequisites = original_config[settings_key]['exec_prerequisites']
original_config[settings_key]["preinstall"] = { 'exec' => exec_prerequisites } if exec_prerequisites
package_prerequisites = original_config[settings_key]['package_prerequisites']
original_config[settings_key]["preinstall"] = { 'package' => package_prerequisites } if package_prerequisites

# Convert postinstall
exec_postinstall = original_config[settings_key]['exec_postinstall']
original_config[settings_key]["postinstall"] = { 'exec' => exec_postinstall } if exec_postinstall
extra_postinstall = original_config[settings_key]['extra_postinstall']
original_config[settings_key]["postinstall"] = { 'extra' => extra_postinstall } if extra_postinstall


# Convert the config to a hash
original_config = original_config.to_hash

# Convert the config to a yaml string
original_config = original_config.to_yaml

# Write the merged config to output file
File.open(output_file_path, 'w') { |file| file.write(original_config.to_yaml) }
