Puppet::Type.newtype(:http_conn_validator) do
  @doc = "Verify that a connection can be successfully established between a node
          and an HTTP server.  Its primary use is as a precondition to
          prevent configuration changes from being applied if the HTTP
          server cannot be reached, but it could potentially be used for other
          purposes such as monitoring."

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true) do
    desc 'An arbitrary name used as the identity of the resource.'
  end

  newparam(:host) do
    desc 'An array containing DNS names or IP addresses of the host where the expected service should be running.'
    munge do |value|
      Array(value).first
    end
  end

  newparam(:port) do
    desc 'The port that the server should be listening on.'
  end

  newparam(:use_ssl) do
    desc 'Whether the connection will be attemped using https'
    defaultto false
  end

  newparam(:test_url) do
    desc 'URL to use for testing if the HTTP server is up'
    defaultto '/'
  end

  newparam(:try_sleep) do
    desc "The time to sleep in seconds between 'tries'."
    defaultto 1

    validate do |value|
      # This will raise an error if the string is not convertible to an integer
      Integer(value)
    end

    munge do |value|
      Integer(value)
    end
  end

  newparam(:timeout) do
    desc 'The max number of seconds that the validator should wait before giving up and deciding that the service is not running; defaults to 60 seconds.'
    defaultto 60

    validate do |value|
      # This will raise an error if the string is not convertible to an integer
      Integer(value)
    end

    munge do |value|
      Integer(value)
    end
  end

  newparam(:expected_code) do
    desc 'The HTTP status code that should be expected; defaults to 200.'
    defaultto 200

    validate do |value|
      # This will raise an error if the string is not convertible to an integer
      Integer(value)
    end

    munge do |value|
      Integer(value)
    end
  end
end
