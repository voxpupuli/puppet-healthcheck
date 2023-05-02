# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'dbbackup' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      tcp_conn_validator { 'beaker ssh test' :
        host => '127.0.0.1',
        port => 22,
      }
      -> file { '/tmp/hello':
      content => "Hi!\n",
      }
      http_conn_validator { 'github https test':
        host          => 'api.github.com',
        port          => '443',
        expected_code => 200,
        verify_peer   => false,
        use_ssl       => true,
        timeout       => 5,
      }
      -> file { '/tmp/foo':
        content => "Hi!\n",
      }
      PUPPET
    end
  end
  describe file('/tmp/hello') do
    it { is_expected.to be_file }
  end

  describe file('/tmp/foo') do
    it { is_expected.to be_file }
  end
end
