# frozen_string_literal: true

require 'spec_helper_acceptance'

if os[:family] == 'redhat'
  shell('yum -y install glibc-common')
  shell('echo "export LANG=C" >> ~/.bashrc')
  shell('echo "export LC_ALL=C" >> ~/.bashrc')
end

if os[:family] == 'debian' || os[:family] == 'ubuntu'
  shell('echo "export LANG=C" >> /etc/default/locale')
  shell('echo "export LC_ALL=C" >> /etc/default/locale')
end

describe 'test noop workflow' do
  context 'noop true' do
    it do
      shell('puppet config set noop true')
      expect(file('/etc/puppetlabs/puppet/puppet.conf')).to contain('noop = true')
    end
  end

  context 'set noop to false' do
    it do
      run_bolt_task('healthcheck::fix_noop')
      expect(file('/etc/puppetlabs/puppet/puppet.conf')).to contain('noop = false')
    end
  end
end
