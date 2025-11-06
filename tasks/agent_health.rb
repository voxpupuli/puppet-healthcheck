#!/opt/puppetlabs/puppet/bin/ruby

require 'open3'
require 'time'
require 'json'
require 'socket'

confprint = 'puppet config print --render-as json'
output, stderr, status = Open3.capture3(confprint)
if status != 0
  puts stderr
  exit 1
end

json = {}
json['issues'] = {}

params = JSON.parse(STDIN.read)
config = JSON.parse(output)

noop_run = if params['_noop']
             true
           else
             false
           end

target_runinterval = if params['target_runinterval']
                       params['target_runinterval'].to_i
                     else
                       1800
                     end

target_noop_state = if params['target_noop_state'].nil?
                      false
                    else
                      params['target_noop_state']
                    end

target_use_cached_catalog_state = if params['target_use_cached_catalog_state'].nil?
                                    false
                                  else
                                    params['target_use_cached_catalog_state']
                                  end

target_service_enabled = if params['target_service_enabled'].nil?
                           true
                         else
                           params['target_service_enabled']
                         end

target_service_running = if params['target_service_running'].nil?
                           'running'
                         elsif params['target_service_running'] == true
                           'running'
                         elsif params['target_service_running'] == false
                           'stopped'
                         else
                           params['target_service_running']
                         end

certname           = config['certname']
pm_port            = config['masterport'].to_i
noop               = config['noop']
use_cached_catalog = config['use_cached_catalog']
lock_file          = config['agent_disabled_lockfile']
interval           = config['runinterval']
statedir           = config['statedir']
compile_masters    = config['server_list'].split(',')
puppetmaster       = config['server']

if noop != target_noop_state
  json['issues']['noop'] = 'noop set to ' + noop.to_s + ' should be ' + target_noop_state.to_s
end

if use_cached_catalog != target_use_cached_catalog_state
  json['issues']['use_cached_catalog'] = 'use_cached_catalog set to ' + use_cached_catalog.to_s + ' should be ' + target_use_cached_catalog_state.to_s
end

if File.file?(lock_file)
  json['issues']['lock_file'] = 'agent disabled lockfile found'
end

if interval.to_i != target_runinterval
  json['issues']['runinterval'] = 'not set to ' + target_runinterval.to_s
end

run_time = 0
last_run = statedir + '/last_run_report.yaml'
if File.file?(last_run)
  last_run_contents = File.open(last_run, 'r').read
  last_run_contents.each_line do |line|
    matchdata = line.match(%r{^time: '(.*)'$})
    next unless matchdata
    run_time = Time.parse(matchdata[1]).to_i
  end
  now = Time.new.to_i
  if (now - interval.to_i) > run_time.to_i
    json['issues']['last_run'] = 'Last run too long ago'
  end
  failcount = 0
  last_run_contents = File.open(last_run, 'r').read
  last_run_contents.each_line do |line|
    matchdata = line.match(%r{.*(fail.*: [1-9]|skipped.*: [1-9])})
    next unless matchdata
    failcount += 1
  end
  if failcount > 0
    json['issues']['failures'] = 'Last run had failures'
  end
else
  json['issues']['last_run'] = 'Cannot locate file : ' + last_run
end

report = statedir + '/last_run_report.yaml'
failcount = 0
if File.file?(report)
  report_contents = File.open(report, 'r').read
  report_contents.each_line do |line|
    matchdata = line.include?('status: failed')
    next unless matchdata
    failcount += 1
  end
  if failcount > 0
    json['issues']['catalog'] = 'Catalog failed to compile'
  end
end

_output, _stderr, status = Open3.capture3('puppet ssl verify')
if status != 0
  json['issues']['signed_cert'] = 'SSL verify error'
end

enabled = false
running = false
output, _stderr, _status = Open3.capture3('puppet resource service puppet')
output.split("\n").each do |line|
  if %r{^\s+enable\s+=> '#{target_service_enabled}',$}.match?(line)
    enabled = true
  end
  if %r{^\s+ensure\s+=> '#{target_service_running}',$}.match?(line)
    running = true
  end
end

if enabled == false
  json['issues']['enabled'] = 'Puppet service enabled not set to ' + target_service_enabled.to_s
end

if running == false
  json['issues']['running'] = 'Puppet service not set to ' + target_service_running.to_s
end

if compile_masters[0]
  compile_masters.each do |compiler|
    TCPSocket.new(compiler, pm_port)
  rescue
    json['issues']['port ' + compiler] = 'Port ' + pm_port.to_s + ' on ' + compiler + ' not reachable'
  end
else
  begin
    TCPSocket.new(puppetmaster, pm_port)
  rescue
    json['issues']['port'] = 'Port ' + pm_port.to_s + ' on ' + puppetmaster + ' not reachable'
  end
end

exit_code, state = if json['issues'].empty?
                     [0, 'clean']
                   else
                     json[:_error] = { msg: 'Issues found', kind: 'puppet_health_check/agent_health' }
                     [1, 'issues found']
                   end

json['state']    = state
json['certname'] = certname
json['date']     = Time.now.iso8601
json['noop_run'] = noop_run
puts JSON.dump(json)
exit exit_code
