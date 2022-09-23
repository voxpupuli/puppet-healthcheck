require 'puppet/network/http_pool'

module PuppetX
  module PuppetCommunity
    class HttpValidator
      attr_reader :test_uri
      attr_reader :test_headers
      attr_reader :expected_code
      attr_reader :options

      def initialize(http_resource_name, http_server, http_port, use_ssl, test_path, expected_code, verify_peer)
        if http_resource_name =~ %r{\A#{URI.regexp}\z}
          @test_uri = URI(http_resource_name)
          @use_ssl     = @test_uri.scheme.eql?('https') ? true : false
        else
          @use_ssl     = use_ssl
          @test_uri    = URI("#{use_ssl ? 'https' : 'http'}://#{http_server}:#{http_port}#{test_path}")
        end
        @test_headers = { 'Accept' => 'application/json' }
        @expected_code = expected_code
        @options = if @use_ssl
                     if verify_peer
                       { include_system_store: true }
                     else
                       { ssl_context: Puppet::SSL::SSLProvider.new.create_insecure_context }
                     end
                   end
      end

      # Utility method; attempts to make an http/https connection to a server.
      # This is abstracted out into a method so that it can be called multiple times
      # for retry attempts.
      #
      # @return true if the connection is successful, false otherwise.
      def attempt_connection
        conn = Puppet.runtime[:http]

        response = conn.get(test_uri, headers: test_headers, options: options)
        unless response.code.to_i == expected_code
          Puppet.notice "Unable to connect to the server or wrong HTTP code (expected #{expected_code}) (#{test_uri}): [#{response.code}] #{response.reason}"
          return false
        end
        return true
      rescue StandardError => e
        Puppet.notice "Unable to connect to the server (#{test_uri}): #{e.message}"
        return false
      end
    end
  end
end
