#!/opt/puppetlabs/puppet/bin/ruby

require 'open3'
require 'time'
require 'json'

confprint = 'puppet config print --render-as json'
output, stderr, status = Open3.capture3(confprint)
if status != 0
  puts stderr
  exit 1
end

json = {}

config = JSON.parse(output)

lock_file = config['agent_disabled_lockfile']

if File.file?(lock_file)
  result = 'agent disabled lockfile found, removing'
  File.delete(lock_file)
else
  result = 'No action required'
end

if json.empty?
  exit_code = 0
  state = 'clean'
else
  exit_code = 1
  state = 'issues found'
end

json['state']    = state
json['certname'] = config['certname']
json['output']   = result
json['date']     = Time.now.iso8601
puts JSON.dump(json)
exit exit_code
