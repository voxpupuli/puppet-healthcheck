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

describe 'test run interval workflow' do
  context 'run interval override' do
    it do
      shell('puppet config set runinterval 3000')
      expect(file('/etc/puppetlabs/puppet/puppet.conf')).to contain('runinterval = 3000')
    end
  end

  context 'fix run interval' do
    it do
      run_bolt_task('healthcheck::fix_runinterval')
      expect(file('/etc/puppetlabs/puppet/puppet.conf')).to contain('runinterval = 1800')
    end
  end
end
