# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'test lockfile workflow' do
  context 'create lockfile' do
    it do
      if host_inventory['kernel']['name'] == 'Windows'
        shell('mkdir  %PROGRAMDATA%\PuppetLabs\puppet\cache\state')
        shell('echo > %PROGRAMDATA%\PuppetLabs\puppet\cache\agent_disabled.lock')
        expect(file('%PROGRAMDATA\PuppetLabs\puppet\cache\agent_disabled.lock')).to be_file
      elsif host_inventory['kernel']['name'] == 'Linux'
        shell('mkdir -p /opt/puppetlabs/puppet/cache/state')
        shell('touch /opt/puppetlabs/puppet/cache/state/agent_disabled.lock')
        expect(file('/opt/puppetlabs/puppet/cache/state/agent_disabled.lock')).to be_file
      end
    end
  end

  context 'remote lockfile' do
    it do
      run_bolt_task('healthcheck::fix_lockfile')
      if host_inventory['kernel']['name'] == 'Windows'
        expect(file('%PROGRAMDATA\PuppetLabs\puppet\cache\agent_disabled.lock')).to be_file
      elsif host_inventory['kernel']['name'] == 'Linux'
        expect(file('/opt/puppetlabs/puppet/cache/state/agent_disabled.lock')).not_to be_file
      end
    end
  end
end
