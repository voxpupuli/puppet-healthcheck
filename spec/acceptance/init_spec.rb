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
      PUPPET
    end
  end
end
