require 'spec_helper_acceptance'

if os[:family] == 'redhat'
  run_shell('yum -y install glibc-common')
  run_shell('echo "export LANG=C" >> ~/.bashrc')
  run_shell('echo "export LC_ALL=C" >> ~/.bashrc')
end

if os[:family] == 'debian' || os[:family] == 'ubuntu'
  run_shell('echo "export LANG=C" >> /etc/default/locale')
  run_shell('echo "export LC_ALL=C" >> /etc/default/locale')
end

describe 'test noop workflow' do
  context 'noop true' do
    it do
      run_shell('puppet config set noop true')
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
